"""Run only in the ZenOS VM with ZEN_SCHEMA_NIXPKGS and ZEN_SCHEMA_HOME_MANAGER."""
import hashlib
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time
import unittest
from unittest.mock import patch

from zenlang import api, parse_file
from zenlang.cli import main
from zenlang.compiler import compile_document, compile_tree
from zenlang.schema_validation import MAX_SCHEMA_BYTES, schema_requests, validate_zcfg
from zenlang.trusted_schema import load_trusted_schema
from zenlang.trusted_schema import _run_context


ROOT = Path(__file__).resolve().parents[3]


@unittest.skipUnless(
    os.environ.get("ZEN_SCHEMA_NIXPKGS") and os.environ.get("ZEN_SCHEMA_HOME_MANAGER"),
    "set ZEN_SCHEMA_NIXPKGS and ZEN_SCHEMA_HOME_MANAGER inside the ZenOS VM",
)
class TrustedSchemaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        temporary = tempfile.TemporaryDirectory(prefix="zen-trusted-fixture-")
        cls.addClassCleanup(temporary.cleanup)
        cls.fixture = Path(temporary.name)
        source = cls.fixture / "source"
        module = source / "modules/programs/demo.zmdl"
        module.parent.mkdir(parents=True)
        module.write_text('''
            port = {
                _meta = { type = $type.int; default = 8080; };
                s!! { warnings = [ ($lib.trivial.throwIf true "trusted action body forced") ]; };
            };
        ''')
        (source / "structure.zstr").write_text('''
            system.programs._meta.type = (zmdl programs);
            system.packages._meta.type = (packages);
            legacy._meta.type = (alias nixpkgs.networking);
        ''')
        bundle = cls.fixture / "bundle.json"
        bundle.write_text(json.dumps(compile_tree(source)))
        nixpkgs = os.environ["ZEN_SCHEMA_NIXPKGS"]
        home_manager = os.environ["ZEN_SCHEMA_HOME_MANAGER"]
        cls.prelude = f'''
            pkgs = import {nixpkgs} {{ system = "x86_64-linux"; }};
            inherit (pkgs) lib;
            bundle = import {ROOT}/lib/read-dsl-bundle.nix {bundle};
            packageTree.tools.demo = pkgs.hello;
            runtime = import {ROOT}/lib/zstr-runtime.nix {{ inherit lib; }};
            evaluate = extraModules: import ({nixpkgs} + "/nixos/lib/eval-config.nix") {{
                system = "x86_64-linux";
                modules = [ ({home_manager} + "/nixos")
                    (runtime.moduleFromBundle {{ inherit bundle packageTree; }})
                    ({{ lib, ... }}: {{ options.networking = {{
                        trustedPositive = lib.mkOption {{
                            type = lib.types.addCheck lib.types.int (x: x > 0);
                        }};
                        trustedPoison = lib.mkOption {{
                            type = lib.types.int;
                            default = builtins.abort "source expression forced poisonous default";
                        }};
                    }}; }})
                ] ++ extraModules;
            }};
            evaluated = evaluate [];
        '''
        cls.context = cls.fixture / "trusted context.nix"
        cls.context.write_text(f'''{{ requests }}:
            let {cls.prelude}
            in import {ROOT}/lib/schema-validation.nix {{ inherit lib; }} {{
                inherit evaluated bundle packageTree requests;
            }}
        ''')

    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="zen-trusted-case-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.host = self.root / "host.zcfg"
        self.host.write_text("system.programs.demo.port = 12;")
        self.output = self.root / "host.nix"
        self.output.write_bytes(b"existing output\n")

    def invoke(self, command="validate", *, context=None, extra=()):
        stdout, stderr = io.StringIO(), io.StringIO()
        arguments = [command, str(self.host), "--trusted-context", str(context or self.context),
                     "--diagnostic-format", "json", *extra]
        if command == "compile":
            arguments += ["-o", str(self.output)]
        code = main(arguments, stdout, stderr)
        diagnostics = []
        for stream in (stdout, stderr):
            if stream.getvalue().strip():
                diagnostics.extend(json.loads(stream.getvalue())["diagnostics"])
        return code, diagnostics

    def assertOutcome(self, outcome, code, diagnostic=None):
        self.assertEqual(outcome[0], code, outcome[1])
        if diagnostic is not None:
            self.assertIn(diagnostic, [item["code"] for item in outcome[1]])

    def test_fresh_requests_after_literal_edits_recheck_upstream_constraints(self):
        # Both literals are ints: rejecting -1 requires a fresh upstream addCheck.
        for value, status in ((3, 0), (-1, 1), (7, 0)):
            with self.subTest(value=value):
                self.host.write_text(f"legacy.trustedPositive = {value};")
                self.assertOutcome(self.invoke(), status, "ZEN502" if status else None)

    def test_typed_boolean_guard_is_incomplete_not_a_frontend_error(self):
        self.host.write_text("if $cfg.system.programs.demo.enable { system.programs.demo.port = 12; };")
        for command in ("validate", "check", "compile"):
            with self.subTest(command=command):
                outcome = self.invoke(command)
                self.assertOutcome(outcome, 2, "ZEN503")
                self.assertNotIn("ZEN220", [item["code"] for item in outcome[1]])
        self.assertEqual(self.output.read_bytes(), b"existing output\n")

    def test_integer_guards_including_or_false_are_rejected(self):
        for guard in ("$cfg.system.programs.demo.port", "$cfg.system.programs.demo.port or false"):
            with self.subTest(guard=guard):
                self.host.write_text(f"if {guard} {{ system.programs.demo.port = 12; }};")
                self.assertOutcome(self.invoke(), 1, "ZEN502")

    def test_valid_incomplete_body_never_forces_source_or_trusted_action(self):
        self.host.write_text('''
            if true { system.programs.demo.port = $cfg.legacy.trustedPoison; };
        ''')
        document = parse_file(self.host, defer_schema_guards=True)
        requests = schema_requests(document)
        self.assertIn({"path": ["legacy", "trustedPoison"]}, requests)
        self.assertFalse(any("value" in item for item in requests))
        for command in ("validate", "compile"):
            with self.subTest(command=command):
                self.assertOutcome(self.invoke(command), 2, "ZEN503")
        self.assertEqual(self.output.read_bytes(), b"existing output\n")

    def test_compile_preserves_existing_output_on_validation_errors(self):
        for source, diagnostic in (
            ('system.programs.demo.port = "bad";', "ZEN502"),
            ("system.programs.missing = true;", "ZEN501"),
        ):
            with self.subTest(source=source):
                self.host.write_text(source)
                self.assertOutcome(self.invoke("compile"), 1, diagnostic)
                self.assertEqual(self.output.read_bytes(), b"existing output\n")

    def test_one_source_parse_and_same_ast_survive_context_time_file_edit(self):
        for command in ("validate", "compile"):
            with self.subTest(command=command):
                self.host.write_text("system.programs.demo.port = 12;")
                documents = []

                def refresh(document, *args, **kwargs):
                    documents.append(document)
                    self.host.write_text('system.programs.demo.port = "edited after parse";')
                    return load_trusted_schema(document, *args, **kwargs)

                with patch("zenlang.api.parse", wraps=api.parse) as parser, \
                     patch("zenlang.cli.load_trusted_schema", side_effect=refresh), \
                     patch("zenlang.cli.validate_zcfg", wraps=validate_zcfg) as validator, \
                     patch("zenlang.cli.compile_document", wraps=compile_document) as compiler:
                    self.assertOutcome(self.invoke(command), 0)
                # Schema annotation parsing is separate from parsing the source AST.
                source_parses = [call for call in parser.call_args_list if call.args[1] == str(self.host)]
                self.assertEqual(len(source_parses), 1)
                self.assertEqual(len(documents), 1)
                self.assertIs(validator.call_args.args[0], documents[0])
                if command == "compile":
                    self.assertIs(compiler.call_args.args[0], documents[0])
                    self.assertNotIn("edited after parse", self.output.read_text())
                    self.assertIn("12", self.output.read_text())

    def test_offline_schema_launches_no_processes(self):
        # Obtain an authentic schema before entering the offline-only boundary.
        result = subprocess.run(
            ["nix", "eval", "--impure", "--json", "--expr",
             f'(import {json.dumps(str(self.context))}) {{ requests = builtins.fromJSON '
             f'{json.dumps(json.dumps(schema_requests(parse_file(self.host))))}; }}'],
            capture_output=True, text=True, timeout=120,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        schema = self.root / "schema.json"
        schema.write_text(result.stdout)
        with patch("subprocess.Popen", side_effect=AssertionError("offline validation launched a process")), \
             patch("zenlang.cli.load_trusted_schema", side_effect=AssertionError("offline mode refreshed schema")):
            for command in ("validate", "check", "compile"):
                with self.subTest(command=command):
                    extra = ["-o", str(self.output)] if command == "compile" else []
                    stderr = io.StringIO()
                    code = main([command, str(self.host), "--schema", str(schema), *extra], io.StringIO(), stderr)
                    self.assertEqual(code, 0, stderr.getvalue())

    def test_missing_context_is_zen504_without_launching_a_process(self):
        with patch("subprocess.Popen", side_effect=AssertionError("missing context launched a process")):
            self.assertOutcome(self.invoke(context=self.root / "missing.nix"), 1, "ZEN504")

    def test_backend_failures_are_zen504_preserve_output_and_clean_artifacts(self):
        for failure in ("exception", "timeout", "exit", "json", "provenance", "size"):
            with self.subTest(failure=failure):
                artifacts, handles = [], []

                def backend(arguments, *, stdout, stderr, timeout, **kwargs):
                    directory = Path(stdout.name).parent
                    artifacts.append(directory)
                    handles.extend((stdout, stderr))
                    request_bytes = (directory / "requests.json").read_bytes()
                    self.assertEqual(json.loads(request_bytes), schema_requests(parse_file(self.host)))
                    self.assertIn(str(directory / "requests.json"), arguments[-1])
                    if failure == "exception":
                        raise OSError("backend unavailable")
                    if failure == "timeout":
                        raise subprocess.TimeoutExpired(arguments, timeout)
                    if failure == "exit":
                        stderr.write(b"trusted backend failed")
                        return subprocess.CompletedProcess(arguments, 9)
                    if failure == "json":
                        stdout.write(b"not JSON")
                    elif failure == "provenance":
                        stale_digest = hashlib.sha256(request_bytes + b" ").hexdigest()
                        stdout.write(json.dumps({"requestDigest": stale_digest, "schema": {}}).encode())
                    elif failure == "size":
                        stdout.seek(MAX_SCHEMA_BYTES)
                        stdout.write(b" ")
                        self.assertEqual(stdout.tell(), MAX_SCHEMA_BYTES + 1)
                    return subprocess.CompletedProcess(arguments, 0)

                with patch("zenlang.trusted_schema._run_context", side_effect=backend) as process:
                    outcome = self.invoke("compile", extra=("--context-timeout", "0.25"))
                self.assertOutcome(outcome, 1, "ZEN504")
                self.assertEqual(process.call_count, 1)
                self.assertEqual(self.output.read_bytes(), b"existing output\n")
                self.assertTrue(artifacts)
                self.assertTrue(all(not path.exists() for path in artifacts))
                self.assertTrue(all(handle.closed for handle in handles))
                if failure == "timeout":
                    self.assertIn("timed out after 0.25 seconds", outcome[1][-1]["message"])
                if failure == "size":
                    self.assertIn("size limit", outcome[1][-1]["message"])

    def test_actual_cli_to_schema_to_compiled_runtime_pipeline(self):
        self.host.write_text("system.programs.demo.port = 42; system.packages.tools.demo = false;")
        result = subprocess.run(
            [sys.executable, "-m", "zenlang", "compile", str(self.host),
             "--trusted-context", str(self.context), "-o", str(self.output)],
            capture_output=True, text=True, timeout=180,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        evaluated = subprocess.run(
            ["nix", "eval", "--impure", "--json", "--expr", f'''
                let {self.prelude}
                    configured = evaluate [ {self.output} ];
                in {{
                    port = configured.config.zenos.system.programs.demo.port;
                    package = configured.config.zenos.system.packages.tools.demo;
                }}
            '''], capture_output=True, text=True, timeout=120,
        )
        self.assertEqual(evaluated.returncode, 0, evaluated.stderr)
        self.assertEqual(json.loads(evaluated.stdout), {"port": 42, "package": False})

    def test_backend_warnings_preserve_json_diagnostic_format(self):
        traced = self.root / "traced.nix"
        traced.write_text(f'requests: builtins.trace "context warning" ((import {json.dumps(str(self.context))}) requests)')
        for command in ("validate", "compile"):
            with self.subTest(command=command):
                self.assertOutcome(self.invoke(command, context=traced), 0, "ZEN505")


class TrustedContextOutputTests(unittest.TestCase):
    def test_failed_backend_terminates_descendants_with_redirected_output(self):
        with tempfile.TemporaryFile() as output, tempfile.TemporaryFile() as log:
            script = (
                "import subprocess,sys; "
                "child = subprocess.Popen([sys.executable, '-c', 'import time; time.sleep(30)'], "
                "stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL); "
                "print(child.pid, flush=True); sys.exit(1)"
            )
            result = _run_context([sys.executable, "-c", script], stdout=output, stderr=log, timeout=5)
            self.assertEqual(result.returncode, 1)
            output.seek(0)
            child = int(output.read())
            try:
                for _ in range(100):
                    status = Path(f"/proc/{child}/stat")
                    if not status.exists() or status.read_text().split(")", 1)[1].split()[0] == "Z":
                        break
                    time.sleep(0.01)
                else:
                    self.fail("failed backend left its child running")
            finally:
                try:
                    os.kill(child, 9)
                except ProcessLookupError:
                    pass

    def test_live_output_limits_terminate_and_reap_backend(self):
        original = subprocess.Popen
        for descriptor in (1, 2):
            with self.subTest(descriptor=descriptor), tempfile.TemporaryFile() as output, tempfile.TemporaryFile() as log:
                processes = []

                def start(*args, **kwargs):
                    process = original(*args, **kwargs)
                    processes.append(process)
                    return process

                before = time.monotonic()
                with patch("zenlang.trusted_schema.subprocess.Popen", side_effect=start), \
                     patch("zenlang.trusted_schema.MAX_SCHEMA_BYTES", 128), \
                     patch("zenlang.trusted_schema.MAX_CONTEXT_LOG_BYTES", 128):
                    with self.assertRaisesRegex(ValueError, "size limit"):
                        _run_context([sys.executable, "-c", f"import os,time; os.write({descriptor}, b'x'*256); time.sleep(10)"],
                                     stdout=output, stderr=log, timeout=5)
                self.assertLess(time.monotonic() - before, 3)
                self.assertIsNotNone(processes[0].poll())
                self.assertLessEqual(output.tell(), 128)
                self.assertLessEqual(log.tell(), 128)

    def test_exact_limits_and_timeout_with_closed_pipes(self):
        with tempfile.TemporaryFile() as output, tempfile.TemporaryFile() as log, \
             patch("zenlang.trusted_schema.MAX_SCHEMA_BYTES", 128), \
             patch("zenlang.trusted_schema.MAX_CONTEXT_LOG_BYTES", 128):
            result = _run_context([sys.executable, "-c", "import os; os.write(1,b'x'*128); os.write(2,b'y'*128)"],
                                  stdout=output, stderr=log, timeout=5)
            self.assertEqual(result.returncode, 0)
            self.assertEqual(output.tell(), 128)
            self.assertEqual(log.tell(), 128)
            before = time.monotonic()
            with self.assertRaises(subprocess.TimeoutExpired):
                _run_context([sys.executable, "-c", "import os,time; os.close(1); os.close(2); time.sleep(10)"],
                             stdout=output, stderr=log, timeout=0.2)
            self.assertLess(time.monotonic() - before, 3)


if __name__ == "__main__":
    unittest.main()
