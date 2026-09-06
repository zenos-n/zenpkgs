"""Refresh mounted validation through an explicitly trusted Nix context."""
from __future__ import annotations

import hashlib
import json
import math
import os
from pathlib import Path
import selectors
import signal
import subprocess
import tempfile
import time
from typing import TextIO

from .emitter import quote_nix_string
from .model import Diagnostic, Document, Span, ZenLangError
from .schema_validation import MAX_SCHEMA_BYTES, SchemaContext, schema_requests


MAX_CONTEXT_LOG_BYTES = 1024 * 1024


def _run_context(arguments, *, stdout, stderr, timeout):
    """Drain both pipes with live byte budgets and terminate failed evaluations."""
    deadline = time.monotonic() + timeout
    with subprocess.Popen(arguments, stdout=subprocess.PIPE, stderr=subprocess.PIPE, start_new_session=True) as process:
        failed = True
        try:
            with selectors.DefaultSelector() as selector:
                selector.register(process.stdout, selectors.EVENT_READ, (stdout, MAX_SCHEMA_BYTES, "response"))
                selector.register(process.stderr, selectors.EVENT_READ, (stderr, MAX_CONTEXT_LOG_BYTES, "diagnostic log"))
                sizes = {stdout: 0, stderr: 0}
                while selector.get_map():
                    remaining = deadline - time.monotonic()
                    if remaining <= 0:
                        raise subprocess.TimeoutExpired(arguments, timeout)
                    for event, _ in selector.select(remaining):
                        target, budget, label = event.data
                        chunk = os.read(event.fileobj.fileno(), 65536)
                        if not chunk:
                            selector.unregister(event.fileobj)
                            continue
                        if sizes[target] + len(chunk) > budget:
                            raise ValueError(f"trusted context {label} exceeds its {budget}-byte size limit")
                        target.write(chunk)
                        sizes[target] += len(chunk)
                result = process.wait(timeout=max(0, deadline - time.monotonic()))
                failed = result != 0
                return subprocess.CompletedProcess(arguments, result)
        finally:
            if failed:
                # Descendants can outlive a failed parent even with closed pipes.
                try:
                    os.killpg(process.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                process.wait()


def load_trusted_schema(
    document: Document, context: str | Path, *, timeout: float = 120,
    stderr: TextIO | None = None,
) -> SchemaContext:
    """Evaluate the context, never the ZCFG. Requests and validation share one AST.

    The trusted file must be a function accepting { requests } and returning the
    schema exporter result. Offline --schema mode never enters this function.
    """
    source = str(context)
    try:
        if not math.isfinite(timeout) or not 0 < timeout <= 600:
            raise ValueError("trusted-context timeout must be greater than 0 and at most 600 seconds")
        context_path = Path(context).resolve(strict=True)
        if context_path.suffix != ".nix" or not context_path.is_file():
            raise ValueError("trusted context must be a regular .nix file")
        requests = json.dumps(schema_requests(document), ensure_ascii=True).encode("utf-8")
        digest = hashlib.sha256(requests).hexdigest()
        with tempfile.TemporaryDirectory(prefix="zen-schema-context-") as directory:
            root = Path(directory)
            request_file = root / "requests.json"
            request_file.write_bytes(requests)
            expression = (
                "let requestText = builtins.readFile (/. + "
                + quote_nix_string(str(request_file)) + "); in { "
                + "requestDigest = builtins.hashString \"sha256\" requestText; "
                + "schema = (import (/. + " + quote_nix_string(str(context_path))
                + ")) { requests = builtins.fromJSON requestText; }; }"
            )
            # The runner caps both streams before writing their temporary files.
            with (root / "response.json").open("w+b") as output, (root / "backend.log").open("w+b") as log:
                result = _run_context(
                    ["nix", "--extra-experimental-features", "nix-command flakes", "eval",
                     "--impure", "--json", "--expr", expression],
                    stdout=output, stderr=log, timeout=timeout,
                )
                log_size = log.tell()
                log.seek(max(0, log_size - 16384))
                details = log.read(16384).decode("utf-8", errors="replace")
                if result.returncode:
                    raise ValueError(f"trusted Nix context failed (exit {result.returncode}):\n{details}")
                if stderr is not None and details:
                    if log_size > 16384:
                        stderr.write("Trusted context diagnostics truncated to the final 16 KiB.\n")
                    stderr.write(details)
                if output.tell() > MAX_SCHEMA_BYTES:
                    raise ValueError("trusted context response exceeds the 32 MiB JSON size limit")
                output.seek(0)
                response = json.load(output)
            if not isinstance(response, dict) or response.get("requestDigest") != digest:
                raise ValueError("trusted context response does not match this request")
            return SchemaContext.from_dict(response.get("schema"), source=source)
    except subprocess.TimeoutExpired as error:
        raise ZenLangError(Diagnostic("ZEN504", f"trusted Nix context timed out after {timeout:g} seconds", Span.point(source))) from error
    except (OSError, ValueError, RecursionError) as error:
        raise ZenLangError(Diagnostic("ZEN504", str(error), Span.point(source))) from error
