"""Run production trusted-context acceptance only inside the ZenOS VM."""
from io import StringIO
import json
from pathlib import Path
import tempfile

from zenlang.cli import main


ROOT = Path(__file__).resolve().parents[2]
CASES = (
    ("validPaths", '''
        system.packages.apps.development-tools.git = true;
        system.packages.legacy.hello = false;
        users.alice.programs.zenlink.autoStart = true;
        legacy.networking.hostName = "schema-validation";
        system.syncthing.guiAddress = "127.0.0.1:8385";
    ''', 0, None),
    ("invalidUserValue", 'users.alice.programs.zenlink.autoStart = "yes";', 1, "ZEN502"),
    ("unknownLegacyPackage", "system.packages.legacy.zenSchemaMissingPackage = true;", 1, "ZEN501"),
    ("booleanGuard", "if $cfg.system.syncthing.enable { system.packages.legacy.hello = true; };", 2, "ZEN503"),
    ("invalidFallbackGuard", "if $cfg.legacy.networking.hostName or false { system.packages.legacy.hello = true; };", 1, "ZEN502"),
    ("stringFallbackComparison", 'if ($cfg.legacy.networking.hostName or "localhost") == "localhost" { system.packages.legacy.hello = true; };', 2, "ZEN503"),
)


def run():
    checks = {}
    with tempfile.TemporaryDirectory(prefix="zen-production-schema-") as directory:
        source = Path(directory) / "host.zcfg"
        output = Path(directory) / "host.nix"
        for name, text, expected, diagnostic in CASES:
            source.write_text(text)
            output.write_text("existing output")
            stdout, stderr = StringIO(), StringIO()
            status = main([
                "compile", str(source), "--trusted-context", str(ROOT / "scripts/schema-context.nix"),
                "--diagnostic-format", "json", "-o", str(output),
            ], stdout, stderr)
            assert status == expected, (name, status, stderr.getvalue())
            if diagnostic:
                assert diagnostic in {item["code"] for item in json.loads(stderr.getvalue())["diagnostics"]}, name
                assert output.read_text() == "existing output", name
            else:
                assert "zenos" in output.read_text(), name
            checks[name] = True
    print(json.dumps(checks, sort_keys=True))


if __name__ == "__main__":
    run()
