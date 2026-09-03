{ lib }:

let
  pathFromDescriptor =
    segments:
    map (
      segment:
      if builtins.elem (segment.kind or null) [ "identifier" "string" ] then
        segment.value
      else
        throw "ZenPkgs DSL adapter requires static attribute paths"
    ) segments;

  decodeValue =
    value:
    if value.type == "literal" then
      value.value
    else if value.type == "string" then
      lib.concatMapStrings (
        part:
        if part.type == "text" then
          part.value
        else
          throw "ZenPkgs DSL adapter does not allow string interpolation"
      ) value.parts
    else if value.type == "list" then
      map decodeValue value.items
    else if value.type == "attr-set" then
      decodeAssignments value.statements
    else if value.type == "group" then
      decodeValue value.value
    else
      throw "ZenPkgs DSL adapter cannot decode ${value.type or "an unknown value type"}"
    ;

  decodeAssignments =
    statements:
    lib.foldl' (
      result: statement:
      if statement.type != "assignment" || statement.operator != "=" then
        throw "ZenPkgs DSL adapter accepts only plain assignments"
      else
        lib.recursiveUpdate result (
          lib.setAttrByPath (pathFromDescriptor statement.target) (decodeValue statement.value)
        )
    ) { } statements;

  decodeInterface =
    descriptor:
    let
      fields = lib.foldl' (
        result: field:
        lib.recursiveUpdate result (lib.setAttrByPath field.path (decodeValue field.value))
      ) { } descriptor.fields;
      expectedFields = [
        "aliases"
        "declarationOrder"
        "id"
        "meta"
        "sourcePath"
        "status"
        "target"
      ];
    in
    assert descriptor.descriptorVersion == "zenlang.semantic/1";
    assert descriptor.kind == "zpkg";
    assert descriptor.imports == [ ];
    assert descriptor.dependencies == {
      global = [ ];
      build = [ ];
      run = [ ];
      export = [ ];
    };
    assert builtins.attrNames fields == expectedFields;
    {
      inherit (fields)
        aliases
        id
        meta
        sourcePath
        status
        target
        ;
      inherit (fields) declarationOrder;
    };
in
{
  inherit decodeInterface decodeValue;

  registryFromBundle =
    {
      bundle,
      bundlePath,
    }:
    let
      sources = builtins.filter (source: source.kind == "zpkg") bundle.sources;
      decoded = map (
        source:
        decodeInterface (import (bundlePath + "/interfaces/${source.path}.nix") { })
      ) sources;
      ordered = lib.sort (left: right: left.declarationOrder < right.declarationOrder) decoded;
      orders = map (entry: entry.declarationOrder) ordered;
    in
    assert bundle.bundleVersion == "zenlang.bundle/1";
    assert builtins.length sources == builtins.length bundle.sources;
    assert builtins.length orders == builtins.length (lib.unique orders);
    {
      schemaVersion = 1;
      packages = map (entry: removeAttrs entry [ "declarationOrder" ]) ordered;
    };
}
