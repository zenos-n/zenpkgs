"""Check actual dconf values against the installed schemas, inside the ZenOS VM."""
import json
from pathlib import Path
import subprocess
import sys
from gi.repository import Gio, GLib

settings = json.loads(Path(sys.argv[1]).read_text())
source = Gio.SettingsSchemaSource.get_default()
for schema_id, key in settings:
    schema = source.lookup(schema_id, True)
    assert schema is not None, f"Missing schema {schema_id}"
    assert schema.has_key(key), f"Missing key {schema_id}.{key}"
    raw = subprocess.check_output(["dconf", "read", schema.get_path() + key], text=True).strip()
    assert raw, f"No configured value for {schema_id}.{key}"
    value = GLib.Variant.parse(None, raw, None, None)
    definition = schema.get_key(key)
    assert value.is_of_type(definition.get_value_type()), (schema_id, key, raw, definition.get_value_type().dup_string())
    assert definition.range_check(value), (schema_id, key, raw)
print(f"Validated {len(settings)} configured desktop preferences against installed GSettings schemas")
