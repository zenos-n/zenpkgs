{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:
let
  cfg = config.zenos.desktops.gnome.extensions.blur-my-shell;
  name = "blur-my-shell";
  mkVariant = (builtins.addErrorContext "_let mkVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: "<${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:22: string interpolation requires a scalar, path, or package") (value))}>"); } ]; }).config.value)));
  mkString = (builtins.addErrorContext "_let mkString annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:23: string interpolation requires a scalar, path, or package") (value))}'"); } ]; }).config.value)));
  mkFloat = (builtins.addErrorContext "_let mkFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
    str = (lib.toString value);
  in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:24: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value)));
  serializeValue = (builtins.addErrorContext "_let serializeValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if (lib.isBool value) then ((if value then "true" else "false")) else (if (lib.isInt value) then (lib.toString value) else (if (lib.isFloat value) then (mkFloat value) else (if (lib.isString value) then (mkString value) else (((lib.throwIfNot false) "Unsupported type in pipeline params: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:30: string interpolation requires a scalar, path, or package") ((lib.typeOf value)))}") "")))))); } ]; }).config.value)));
  serializeParams = (builtins.addErrorContext "_let serializeParams annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (params: (if (params == { }) then "@a{sv} {}" else (let
    keys = ((lib.sort ((a: (b: (a < b))))) ((lib.attrNames params)));
    pairs = ((lib.map ((key: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:36: string interpolation requires a scalar, path, or package") ((mkString key)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:36: string interpolation requires a scalar, path, or package") ((mkVariant ((serializeValue (((lib.getAttr key) params)))))))}"))) keys);
  in "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:37: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") pairs)))}}"))); } ]; }).config.value)));
  padId = (builtins.addErrorContext "_let padId annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:38:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (let
    str = (lib.toString index);
    zeros = "000000000000";
  in "effect_${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:42: string interpolation requires a scalar, path, or package") ((((lib.substring 0) ((12 - (lib.stringLength str)))) zeros)))}${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:42: string interpolation requires a scalar, path, or package") (str))}")); } ]; }).config.value)));
  normalizeEffect = (builtins.addErrorContext "_let normalizeEffect annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:43:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (effectAttrs: (let
    generatedId = (padId index);
    process = (type: (params: {
      inherit type params;
      id = (effectAttrs.id or generatedId);
    }));
  in (if ((lib.hasAttrByPath [
    "blur"
    "gaussian"
  ]) effectAttrs) then ((process "native_static_gaussian_blur") (((lib.getAttrFromPath [
    "blur"
    "gaussian"
  ]) effectAttrs))) else (if ((lib.hasAttrByPath [
    "blur"
    "monte_carlo"
  ]) effectAttrs) then ((process "monte_carlo_blur") (((lib.getAttrFromPath [
    "blur"
    "monte_carlo"
  ]) effectAttrs))) else (if ((lib.hasAttr "corner") effectAttrs) then ((process "corner") effectAttrs.corner) else (if ((lib.hasAttr "noise") effectAttrs) then ((process "noise") effectAttrs.noise) else (if ((lib.hasAttr "color") effectAttrs) then ((process "color") effectAttrs.color) else (if ((lib.hasAttr "pixelize") effectAttrs) then ((process "pixelize") effectAttrs.pixelize) else (if ((lib.hasAttr "derivative") effectAttrs) then ((process "derivative") effectAttrs.derivative) else (if ((lib.hasAttr "type") effectAttrs) then ((process effectAttrs.type) ((effectAttrs.params or { }))) else (((lib.throwIfNot false) "Unknown effect type in pipeline configuration") { })))))))))))); } ]; }).config.value)));
  serializeEffect = (builtins.addErrorContext "_let serializeEffect annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:56:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (effectAttrs: (let
    normalized = ((normalizeEffect index) effectAttrs);
    dict = "{'type': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString normalized.type)))))}, 'id': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString normalized.id)))))}, 'params': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((serializeParams normalized.params)))))}}";
  in (mkVariant dict)))); } ]; }).config.value)));
  serializePipeline = (builtins.addErrorContext "_let serializePipeline annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:61:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (pipeline: (let
    serializedEffects = ((lib.imap0 serializeEffect) pipeline.effects);
  in "{'name': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString pipeline.name)))))}, 'effects': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") ((mkVariant "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") serializedEffects)))}]")))}}")); } ]; }).config.value)));
  pipelinesGVariant = (builtins.addErrorContext "_let pipelinesGVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.mapAttrsToList ((id: (pipeline: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") ((mkString id)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") ((serializePipeline pipeline)))}")))) cfg.general.pipelines)))))}}"; } ]; }).config.value)));
in
{
  options.zenos.desktops.gnome.extensions.blur-my-shell = lib.mkOption { type = (lib.types.submodule ({ ... }: (let mkVariant = (builtins.addErrorContext "_let mkVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: "<${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:22: string interpolation requires a scalar, path, or package") (value))}>"); } ]; }).config.value))); mkString = (builtins.addErrorContext "_let mkString annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:23: string interpolation requires a scalar, path, or package") (value))}'"); } ]; }).config.value))); mkFloat = (builtins.addErrorContext "_let mkFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
        str = (lib.toString value);
      in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:24: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value))); serializeValue = (builtins.addErrorContext "_let serializeValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if (lib.isBool value) then ((if value then "true" else "false")) else (if (lib.isInt value) then (lib.toString value) else (if (lib.isFloat value) then (mkFloat value) else (if (lib.isString value) then (mkString value) else (((lib.throwIfNot false) "Unsupported type in pipeline params: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:30: string interpolation requires a scalar, path, or package") ((lib.typeOf value)))}") "")))))); } ]; }).config.value))); serializeParams = (builtins.addErrorContext "_let serializeParams annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (params: (if (params == { }) then "@a{sv} {}" else (let
        keys = ((lib.sort ((a: (b: (a < b))))) ((lib.attrNames params)));
        pairs = ((lib.map ((key: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:36: string interpolation requires a scalar, path, or package") ((mkString key)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:36: string interpolation requires a scalar, path, or package") ((mkVariant ((serializeValue (((lib.getAttr key) params)))))))}"))) keys);
      in "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:37: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") pairs)))}}"))); } ]; }).config.value))); padId = (builtins.addErrorContext "_let padId annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:38:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (let
        str = (lib.toString index);
        zeros = "000000000000";
      in "effect_${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:42: string interpolation requires a scalar, path, or package") ((((lib.substring 0) ((12 - (lib.stringLength str)))) zeros)))}${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:42: string interpolation requires a scalar, path, or package") (str))}")); } ]; }).config.value))); normalizeEffect = (builtins.addErrorContext "_let normalizeEffect annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:43:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (effectAttrs: (let
        generatedId = (padId index);
        process = (type: (params: {
          inherit type params;
          id = (effectAttrs.id or generatedId);
        }));
      in (if ((lib.hasAttrByPath [
        "blur"
        "gaussian"
      ]) effectAttrs) then ((process "native_static_gaussian_blur") (((lib.getAttrFromPath [
        "blur"
        "gaussian"
      ]) effectAttrs))) else (if ((lib.hasAttrByPath [
        "blur"
        "monte_carlo"
      ]) effectAttrs) then ((process "monte_carlo_blur") (((lib.getAttrFromPath [
        "blur"
        "monte_carlo"
      ]) effectAttrs))) else (if ((lib.hasAttr "corner") effectAttrs) then ((process "corner") effectAttrs.corner) else (if ((lib.hasAttr "noise") effectAttrs) then ((process "noise") effectAttrs.noise) else (if ((lib.hasAttr "color") effectAttrs) then ((process "color") effectAttrs.color) else (if ((lib.hasAttr "pixelize") effectAttrs) then ((process "pixelize") effectAttrs.pixelize) else (if ((lib.hasAttr "derivative") effectAttrs) then ((process "derivative") effectAttrs.derivative) else (if ((lib.hasAttr "type") effectAttrs) then ((process effectAttrs.type) ((effectAttrs.params or { }))) else (((lib.throwIfNot false) "Unknown effect type in pipeline configuration") { })))))))))))); } ]; }).config.value))); serializeEffect = (builtins.addErrorContext "_let serializeEffect annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:56:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (effectAttrs: (let
        normalized = ((normalizeEffect index) effectAttrs);
        dict = "{'type': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString normalized.type)))))}, 'id': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString normalized.id)))))}, 'params': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((serializeParams normalized.params)))))}}";
      in (mkVariant dict)))); } ]; }).config.value))); serializePipeline = (builtins.addErrorContext "_let serializePipeline annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:61:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (pipeline: (let
        serializedEffects = ((lib.imap0 serializeEffect) pipeline.effects);
      in "{'name': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString pipeline.name)))))}, 'effects': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") ((mkVariant "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") serializedEffects)))}]")))}}")); } ]; }).config.value))); pipelinesGVariant = (builtins.addErrorContext "_let pipelinesGVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.mapAttrsToList ((id: (pipeline: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") ((mkString id)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") ((serializePipeline pipeline)))}")))) cfg.general.pipelines)))))}}"; } ]; }).config.value))); in { options = { appfolder = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to activate blur for this component"; }; brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Brightness of the blur effect"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Color to mix with the blur (GVariant tuple string)"; }; customize = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to customize sigma/brightness or use global values"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount of noise to add"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Lightness of the noise"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma (blur strength)"; }; style-dialogs = lib.mkOption { type = lib.types.int; default = 1; description = "Folder dialog visual style (0-3)"; }; }; })); default = { }; }; applications = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blacklist = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [
  "Plank"
  "com.desktop.ding"
  "Conky"
]; description = "App IDs to explicitly exclude from blur"; }; blur = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to activate blur for this component"; }; blur-on-overview = lib.mkOption { type = lib.types.bool; default = false; description = "Keep window blur active in overview"; }; brightness = lib.mkOption { type = lib.types.float; default = 1.0; description = "Brightness of the blur effect"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Color to mix with the blur (GVariant tuple string)"; }; customize = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to customize sigma/brightness or use global values"; }; dynamic-opacity = lib.mkOption { type = lib.types.bool; default = true; description = "Restore full opacity on window focus"; }; enable-all = lib.mkOption { type = lib.types.bool; default = false; description = "Attempt to blur all window actors"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount of noise to add"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Lightness of the noise"; }; opacity = lib.mkOption { type = lib.types.int; default = 215; description = "Alpha opacity for blurred windows"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma (blur strength)"; }; whitelist = lib.mkOption { type = (lib.types.listOf lib.types.str); default = [ ]; description = "App IDs to explicitly include in blur"; }; }; })); default = { }; }; coverflow-alt-tab = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur = lib.mkOption { type = lib.types.bool; default = true; description = "Enable blur for coverflow switcher"; }; pipeline = lib.mkOption { type = lib.types.str; default = "pipeline_default"; description = "Pipeline for the coverflow background"; }; }; })); default = { }; }; dash-to-dock = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to activate blur for this component"; }; brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Brightness of the blur effect"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Color to mix with the blur (GVariant tuple string)"; }; corner-radius = lib.mkOption { type = lib.types.int; default = 12; description = "Corner rounding radius for the blur actor"; }; customize = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to customize sigma/brightness or use global values"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount of noise to add"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Lightness of the noise"; }; override-background = lib.mkOption { type = lib.types.bool; default = true; description = "Override dock background settings"; }; pipeline = lib.mkOption { type = lib.types.str; default = "pipeline_default_rounded"; description = "Pipeline applied to the dock"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma (blur strength)"; }; static-blur = lib.mkOption { type = lib.types.bool; default = true; description = "Use static blur for the dock"; }; style-dash-to-dock = lib.mkOption { type = lib.types.int; default = 0; description = "Dock transparency style (0-2)"; }; unblur-in-overview = lib.mkOption { type = lib.types.bool; default = false; description = "Disable blur in activity overview"; }; }; })); default = { }; }; dash-to-panel = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur-original-panel = lib.mkOption { type = lib.types.bool; default = true; description = "Blur the Dash to Panel actor"; }; }; })); default = { }; }; enable = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to enable Blur My Shell GNOME extension configuration."; }; general = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Global brightness adjustment for blur"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Global color mix (GVariant tuple)"; }; color-and-noise = lib.mkOption { type = lib.types.bool; default = true; description = "Apply color and noise filters globally"; }; debug = lib.mkOption { type = lib.types.bool; default = false; description = "Enable verbose console output for debugging"; }; hacks-level = lib.mkOption { type = lib.types.int; default = 1; description = "Performance/Compatibility hack level (0-2)"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Global film grain/noise intensity"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Global noise lightness adjustment"; }; pipelines = lib.mkOption { type = (lib.types.attrsOf lib.types.attrs); default = { }; description = "Advanced effect pipeline definitions"; }; settings-version = lib.mkOption { type = lib.types.int; default = 1; description = "Internal version tracker for settings"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Global gaussian sigma (blur radius)"; }; }; })); default = { }; }; hidetopbar = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { compatibility = lib.mkOption { type = lib.types.bool; default = false; description = "Toggle compatibility hacks for Hide Top Bar"; }; }; })); default = { }; }; lockscreen = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to activate blur for this component"; }; brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Brightness of the blur effect"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Color to mix with the blur (GVariant tuple string)"; }; customize = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to customize sigma/brightness or use global values"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount of noise to add"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Lightness of the noise"; }; pipeline = lib.mkOption { type = lib.types.str; default = "pipeline_default"; description = "Pipeline for the lockscreen background"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma (blur strength)"; }; }; })); default = { }; }; overview = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to activate blur for this component"; }; brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Brightness of the blur effect"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Color to mix with the blur (GVariant tuple string)"; }; customize = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to customize sigma/brightness or use global values"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount of noise to add"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Lightness of the noise"; }; pipeline = lib.mkOption { type = lib.types.str; default = "pipeline_default"; description = "Pipeline applied to the overview background"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma (blur strength)"; }; style-components = lib.mkOption { type = lib.types.int; default = 1; description = "Component transparency style (0-3)"; }; }; })); default = { }; }; panel = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to activate blur for this component"; }; brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Brightness of the blur effect"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Color to mix with the blur (GVariant tuple string)"; }; customize = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to customize sigma/brightness or use global values"; }; force-light-text = lib.mkOption { type = lib.types.bool; default = false; description = "Force white text on blurred panel"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount of noise to add"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Lightness of the noise"; }; override-background = lib.mkOption { type = lib.types.bool; default = true; description = "Force panel background override"; }; override-background-dynamically = lib.mkOption { type = lib.types.bool; default = false; description = "Toggle blur based on window overlap"; }; pipeline = lib.mkOption { type = lib.types.str; default = "pipeline_default"; description = "Pipeline applied to the panel"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma (blur strength)"; }; static-blur = lib.mkOption { type = lib.types.bool; default = true; description = "Use static image blur instead of live blur"; }; style-panel = lib.mkOption { type = lib.types.int; default = 0; description = "Panel transparency style (0-3)"; }; unblur-in-overview = lib.mkOption { type = lib.types.bool; default = true; description = "Disable blur when entering the overview"; }; }; })); default = { }; }; screenshot = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to activate blur for this component"; }; brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Brightness of the blur effect"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Color to mix with the blur (GVariant tuple string)"; }; customize = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to customize sigma/brightness or use global values"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount of noise to add"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Lightness of the noise"; }; pipeline = lib.mkOption { type = lib.types.str; default = "pipeline_default"; description = "Pipeline for the screenshot interface"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma (blur strength)"; }; }; })); default = { }; }; window-list = lib.mkOption { type = (lib.types.submodule ({ ... }: { options = { blur = lib.mkOption { type = lib.types.bool; default = true; description = "Whether to activate blur for this component"; }; brightness = lib.mkOption { type = lib.types.float; default = 0.6; description = "Brightness of the blur effect"; }; color = lib.mkOption { type = lib.types.str; default = "(0.0,0.0,0.0,0.0)"; description = "Color to mix with the blur (GVariant tuple string)"; }; customize = lib.mkOption { type = lib.types.bool; default = false; description = "Whether to customize sigma/brightness or use global values"; }; noise-amount = lib.mkOption { type = lib.types.float; default = 0.0; description = "Amount of noise to add"; }; noise-lightness = lib.mkOption { type = lib.types.float; default = 0.0; description = "Lightness of the noise"; }; pipeline = lib.mkOption { type = lib.types.str; default = "pipeline_default"; description = "Pipeline for the window list bar"; }; sigma = lib.mkOption { type = lib.types.int; default = 30; description = "Gaussian sigma (blur strength)"; }; }; })); default = { }; }; }; }))); default = { }; };
  config = lib.mkMerge [
    { _module.args.zenlang.descriptors.desktops.gnome.extensions.blur-my-shell = {
    aliases = [ ];
    descriptorVersion = "zenlang.semantic/2";
    grammarVersion = "1.0.0Na";
    irVersion = "1.0.0Na";
    kind = "zmdl";
    metadata = {
      description = {
        multiline = true;
        parts = [
          {
            type = "text";
            value = "\n    Aesthetic blur effects for GNOME Shell components\n\n    This module installs and configures the **Blur My Shell** extension for GNOME.\n    It adds a blur look to different parts of the GNOME Shell, including the top panel,\n    dash, overview, and applications.\n\n    **Features:**\n    - Global blur settings (sigma, brightness, noise).\n    - Per-component configuration (Panel, Dock, Overview, Lockscreen).\n    - Advanced pipeline support for custom effects.\n    - Application whitelist/blacklist.\n  ";
          }
        ];
        type = "string";
      };
      license = {
        name = "l";
        path = [
          {
            kind = "identifier";
            value = "napl";
          }
        ];
        type = "variable";
      };
      maintainers = {
        items = [
          {
            name = "m";
            path = [
              {
                kind = "identifier";
                value = "doromiert";
              }
            ];
            type = "variable";
          }
        ];
        type = "list";
      };
      platforms = {
        name = "lib";
        path = [
          {
            kind = "identifier";
            value = "platforms";
          }
          {
            kind = "identifier";
            value = "zenos";
          }
        ];
        type = "variable";
      };
      summary = {
        multiline = false;
        parts = [
          {
            type = "text";
            value = "Aesthetic blur effects for GNOME Shell components";
          }
        ];
        type = "string";
      };
      zenosVersion = {
        kind = "version";
        type = "literal";
        value = "1.0.0Na";
      };
    };
    moduleIdentity = "zenos.desktops.gnome.extensions.blur-my-shell";
    modulePath = [
      "desktops"
      "gnome"
      "extensions"
      "blur-my-shell"
    ];
    nodeMetadata = [
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "\n    Aesthetic blur effects for GNOME Shell components\n\n    This module installs and configures the **Blur My Shell** extension for GNOME.\n    It adds a blur look to different parts of the GNOME Shell, including the top panel,\n    dash, overview, and applications.\n\n    **Features:**\n    - Global blur settings (sigma, brightness, noise).\n    - Per-component configuration (Panel, Dock, Overview, Lockscreen).\n    - Advanced pipeline support for custom effects.\n    - Application whitelist/blacklist.\n  ";
              }
            ];
            type = "string";
          };
          license = {
            name = "l";
            path = [
              {
                kind = "identifier";
                value = "napl";
              }
            ];
            type = "variable";
          };
          maintainers = {
            items = [
              {
                name = "m";
                path = [
                  {
                    kind = "identifier";
                    value = "doromiert";
                  }
                ];
                type = "variable";
              }
            ];
            type = "list";
          };
          platforms = {
            name = "lib";
            path = [
              {
                kind = "identifier";
                value = "platforms";
              }
              {
                kind = "identifier";
                value = "zenos";
              }
            ];
            type = "variable";
          };
          summary = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "Aesthetic blur effects for GNOME Shell components";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [ ];
      }
      {
        metadata = {
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to enable Blur My Shell GNOME extension configuration.";
              }
            ];
            type = "string";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "enable"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 1;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Internal version tracker for settings";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "settings-version"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Global gaussian sigma (blur radius)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Global brightness adjustment for blur";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Global color mix (GVariant tuple)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Global film grain/noise intensity";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Global noise lightness adjustment";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Apply color and noise filters globally";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "color-and-noise"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 1;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Performance/Compatibility hack level (0-2)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "hacks-level"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Enable verbose console output for debugging";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "debug"
        ];
      }
      {
        metadata = {
          default = {
            recursive = false;
            statements = [ ];
            type = "attr-set";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Advanced effect pipeline definitions";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "set";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "set";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "general"
          "pipelines"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to activate blur for this component";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to customize sigma/brightness or use global values";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "customize"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma (blur strength)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Brightness of the blur effect";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Color to mix with the blur (GVariant tuple string)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount of noise to add";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Lightness of the noise";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pipeline_default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pipeline applied to the overview background";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "pipeline"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 1;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Component transparency style (0-3)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "overview"
          "style-components"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to activate blur for this component";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to customize sigma/brightness or use global values";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
          "customize"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma (blur strength)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Brightness of the blur effect";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Color to mix with the blur (GVariant tuple string)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount of noise to add";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Lightness of the noise";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 1;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Folder dialog visual style (0-3)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "appfolder"
          "style-dialogs"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to activate blur for this component";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to customize sigma/brightness or use global values";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "customize"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma (blur strength)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Brightness of the blur effect";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Color to mix with the blur (GVariant tuple string)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount of noise to add";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Lightness of the noise";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pipeline_default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pipeline applied to the panel";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "pipeline"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Use static image blur instead of live blur";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "static-blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Disable blur when entering the overview";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "unblur-in-overview"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Force white text on blurred panel";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "force-light-text"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Force panel background override";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "override-background"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Panel transparency style (0-3)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "style-panel"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Toggle blur based on window overlap";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "panel"
          "override-background-dynamically"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to activate blur for this component";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to customize sigma/brightness or use global values";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "customize"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma (blur strength)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Brightness of the blur effect";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Color to mix with the blur (GVariant tuple string)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount of noise to add";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Lightness of the noise";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pipeline_default_rounded";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pipeline applied to the dock";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "pipeline"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Use static blur for the dock";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "static-blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Override dock background settings";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "override-background"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Dock transparency style (0-2)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "style-dash-to-dock"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Disable blur in activity overview";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "unblur-in-overview"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 12;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Corner rounding radius for the blur actor";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-dock"
          "corner-radius"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to activate blur for this component";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to customize sigma/brightness or use global values";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "customize"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma (blur strength)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 1.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Brightness of the blur effect";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Color to mix with the blur (GVariant tuple string)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount of noise to add";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Lightness of the noise";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 215;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Alpha opacity for blurred windows";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "opacity"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Restore full opacity on window focus";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "dynamic-opacity"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Keep window blur active in overview";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "blur-on-overview"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Attempt to blur all window actors";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "enable-all"
        ];
      }
      {
        metadata = {
          default = {
            items = [ ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "App IDs to explicitly include in blur";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "whitelist"
        ];
      }
      {
        metadata = {
          default = {
            items = [
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "Plank";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "com.desktop.ding";
                  }
                ];
                type = "string";
              }
              {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "Conky";
                  }
                ];
                type = "string";
              }
            ];
            type = "list";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "App IDs to explicitly exclude from blur";
              }
            ];
            type = "string";
          };
          type = {
            arguments = [
              {
                items = [
                  {
                    name = "type";
                    path = [
                      {
                        kind = "identifier";
                        value = "string";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              }
            ];
            callee = {
              name = "type";
              path = [
                {
                  kind = "identifier";
                  value = "list";
                }
              ];
              type = "variable";
            };
            type = "call";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "applications"
          "blacklist"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to activate blur for this component";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to customize sigma/brightness or use global values";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
          "customize"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma (blur strength)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Brightness of the blur effect";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Color to mix with the blur (GVariant tuple string)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount of noise to add";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Lightness of the noise";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pipeline_default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pipeline for the screenshot interface";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "screenshot"
          "pipeline"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to activate blur for this component";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to customize sigma/brightness or use global values";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
          "customize"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma (blur strength)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Brightness of the blur effect";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Color to mix with the blur (GVariant tuple string)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount of noise to add";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Lightness of the noise";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pipeline_default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pipeline for the lockscreen background";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "lockscreen"
          "pipeline"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to activate blur for this component";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Whether to customize sigma/brightness or use global values";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
          "customize"
        ];
      }
      {
        metadata = {
          default = {
            kind = "integer";
            type = "literal";
            value = 30;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Gaussian sigma (blur strength)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "int";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
          "sigma"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.6;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Brightness of the blur effect";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
          "brightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "(0.0,0.0,0.0,0.0)";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Color to mix with the blur (GVariant tuple string)";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
          "color"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Amount of noise to add";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
          "noise-amount"
        ];
      }
      {
        metadata = {
          default = {
            kind = "float";
            type = "literal";
            value = 0.0;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Lightness of the noise";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "float";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
          "noise-lightness"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pipeline_default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pipeline for the window list bar";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "window-list"
          "pipeline"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "coverflow-alt-tab"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Enable blur for coverflow switcher";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "coverflow-alt-tab"
          "blur"
        ];
      }
      {
        metadata = {
          default = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "pipeline_default";
              }
            ];
            type = "string";
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Pipeline for the coverflow background";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "string";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "coverflow-alt-tab"
          "pipeline"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "hidetopbar"
        ];
      }
      {
        metadata = {
          default = {
            kind = "false";
            type = "literal";
            value = false;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Toggle compatibility hacks for Hide Top Bar";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "hidetopbar"
          "compatibility"
        ];
      }
      {
        metadata = {
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-panel"
        ];
      }
      {
        metadata = {
          default = {
            kind = "true";
            type = "literal";
            value = true;
          };
          description = {
            multiline = true;
            parts = [
              {
                type = "text";
                value = "Blur the Dash to Panel actor";
              }
            ];
            type = "string";
          };
          type = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "bool";
              }
            ];
            type = "variable";
          };
          zenosVersion = {
            kind = "version";
            type = "literal";
            value = "1.0.0Na";
          };
        };
        path = [
          "dash-to-panel"
          "blur-original-panel"
        ];
      }
    ];
    statements = [
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "_meta";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "zenosVersion";
                }
              ];
              type = "assignment";
              value = {
                kind = "version";
                type = "literal";
                value = "1.0.0Na";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "summary";
                }
              ];
              type = "assignment";
              value = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "Aesthetic blur effects for GNOME Shell components";
                  }
                ];
                type = "string";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "description";
                }
              ];
              type = "assignment";
              value = {
                multiline = true;
                parts = [
                  {
                    type = "text";
                    value = "\n    Aesthetic blur effects for GNOME Shell components\n\n    This module installs and configures the **Blur My Shell** extension for GNOME.\n    It adds a blur look to different parts of the GNOME Shell, including the top panel,\n    dash, overview, and applications.\n\n    **Features:**\n    - Global blur settings (sigma, brightness, noise).\n    - Per-component configuration (Panel, Dock, Overview, Lockscreen).\n    - Advanced pipeline support for custom effects.\n    - Application whitelist/blacklist.\n  ";
                  }
                ];
                type = "string";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "maintainers";
                }
              ];
              type = "assignment";
              value = {
                items = [
                  {
                    name = "m";
                    path = [
                      {
                        kind = "identifier";
                        value = "doromiert";
                      }
                    ];
                    type = "variable";
                  }
                ];
                type = "list";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "license";
                }
              ];
              type = "assignment";
              value = {
                name = "l";
                path = [
                  {
                    kind = "identifier";
                    value = "napl";
                  }
                ];
                type = "variable";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "platforms";
                }
              ];
              type = "assignment";
              value = {
                name = "lib";
                path = [
                  {
                    kind = "identifier";
                    value = "platforms";
                  }
                  {
                    kind = "identifier";
                    value = "zenos";
                  }
                ];
                type = "variable";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "value";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "mkVariant";
        type = "let-binding";
        value = {
          body = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "<";
              }
              {
                expression = {
                  path = [
                    {
                      kind = "identifier";
                      value = "value";
                    }
                  ];
                  type = "reference";
                };
                type = "interpolation";
              }
              {
                type = "text";
                value = ">";
              }
            ];
            type = "string";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "value";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "value";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "mkString";
        type = "let-binding";
        value = {
          body = {
            multiline = false;
            parts = [
              {
                type = "text";
                value = "'";
              }
              {
                expression = {
                  path = [
                    {
                      kind = "identifier";
                      value = "value";
                    }
                  ];
                  type = "reference";
                };
                type = "interpolation";
              }
              {
                type = "text";
                value = "'";
              }
            ];
            type = "string";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "value";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "float";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "mkFloat";
        type = "let-binding";
        value = {
          body = {
            body = {
              condition = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "str";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  arguments = [
                    {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = ".";
                        }
                      ];
                      type = "string";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "hasInfix";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
                type = "call";
              };
              "else" = {
                multiline = false;
                parts = [
                  {
                    expression = {
                      path = [
                        {
                          kind = "identifier";
                          value = "str";
                        }
                      ];
                      type = "reference";
                    };
                    type = "interpolation";
                  }
                  {
                    type = "text";
                    value = ".0";
                  }
                ];
                type = "string";
              };
              "then" = {
                path = [
                  {
                    kind = "identifier";
                    value = "str";
                  }
                ];
                type = "reference";
              };
              type = "if";
            };
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "str";
                  }
                ];
                type = "assignment";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "value";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "toString";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
              }
            ];
            type = "let";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "value";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "value";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "serializeValue";
        type = "let-binding";
        value = {
          body = {
            condition = {
              arguments = [
                {
                  path = [
                    {
                      kind = "identifier";
                      value = "value";
                    }
                  ];
                  type = "reference";
                }
              ];
              callee = {
                name = "lib";
                path = [
                  {
                    kind = "identifier";
                    value = "isBool";
                  }
                ];
                type = "variable";
              };
              type = "call";
            };
            "else" = {
              condition = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "value";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "isInt";
                    }
                  ];
                  type = "variable";
                };
                type = "call";
              };
              "else" = {
                condition = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "value";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "isFloat";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
                "else" = {
                  condition = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "value";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "isString";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                  "else" = {
                    arguments = [
                      {
                        multiline = false;
                        parts = [ ];
                        type = "string";
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "Unsupported type in pipeline params: ";
                            }
                            {
                              expression = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "value";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                callee = {
                                  name = "lib";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "typeOf";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                              type = "interpolation";
                            }
                          ];
                          type = "string";
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            kind = "false";
                            type = "literal";
                            value = false;
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "throwIfNot";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                  "then" = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "value";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      name = "v";
                      path = [
                        {
                          kind = "identifier";
                          value = "mkString";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                  type = "if";
                };
                "then" = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "value";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    name = "v";
                    path = [
                      {
                        kind = "identifier";
                        value = "mkFloat";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
                type = "if";
              };
              "then" = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "value";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  name = "lib";
                  path = [
                    {
                      kind = "identifier";
                      value = "toString";
                    }
                  ];
                  type = "variable";
                };
                type = "call";
              };
              type = "if";
            };
            "then" = {
              type = "group";
              value = {
                condition = {
                  path = [
                    {
                      kind = "identifier";
                      value = "value";
                    }
                  ];
                  type = "reference";
                };
                "else" = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "false";
                    }
                  ];
                  type = "string";
                };
                "then" = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "true";
                    }
                  ];
                  type = "string";
                };
                type = "if";
              };
            };
            type = "if";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "value";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "params";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "serializeParams";
        type = "let-binding";
        value = {
          body = {
            condition = {
              left = {
                path = [
                  {
                    kind = "identifier";
                    value = "params";
                  }
                ];
                type = "reference";
              };
              operator = "==";
              right = {
                recursive = false;
                statements = [ ];
                type = "attr-set";
              };
              type = "binary";
            };
            "else" = {
              body = {
                multiline = false;
                parts = [
                  {
                    type = "text";
                    value = "{";
                  }
                  {
                    expression = {
                      arguments = [
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "pairs";
                            }
                          ];
                          type = "reference";
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = ", ";
                              }
                            ];
                            type = "string";
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "concatStringsSep";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                    type = "interpolation";
                  }
                  {
                    type = "text";
                    value = "}";
                  }
                ];
                type = "string";
              };
              statements = [
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "keys";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        type = "group";
                        value = {
                          arguments = [
                            {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "params";
                                }
                              ];
                              type = "reference";
                            }
                          ];
                          callee = {
                            name = "lib";
                            path = [
                              {
                                kind = "identifier";
                                value = "attrNames";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          type = "group";
                          value = {
                            body = {
                              body = {
                                left = {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "a";
                                    }
                                  ];
                                  type = "reference";
                                };
                                operator = "<";
                                right = {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "b";
                                    }
                                  ];
                                  type = "reference";
                                };
                                type = "binary";
                              };
                              form = "identifier";
                              parameters = [
                                {
                                  default = null;
                                  name = "b";
                                  variadic = false;
                                }
                              ];
                              type = "lambda";
                            };
                            form = "identifier";
                            parameters = [
                              {
                                default = null;
                                name = "a";
                                variadic = false;
                              }
                            ];
                            type = "lambda";
                          };
                        }
                      ];
                      callee = {
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "sort";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "pairs";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "keys";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          type = "group";
                          value = {
                            body = {
                              multiline = false;
                              parts = [
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "key";
                                          }
                                        ];
                                        type = "reference";
                                      }
                                    ];
                                    callee = {
                                      name = "v";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "mkString";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = ": ";
                                }
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        type = "group";
                                        value = {
                                          arguments = [
                                            {
                                              type = "group";
                                              value = {
                                                arguments = [
                                                  {
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "params";
                                                      }
                                                    ];
                                                    type = "reference";
                                                  }
                                                ];
                                                callee = {
                                                  arguments = [
                                                    {
                                                      path = [
                                                        {
                                                          kind = "identifier";
                                                          value = "key";
                                                        }
                                                      ];
                                                      type = "reference";
                                                    }
                                                  ];
                                                  callee = {
                                                    name = "lib";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "getAttr";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  };
                                                  type = "call";
                                                };
                                                type = "call";
                                              };
                                            }
                                          ];
                                          callee = {
                                            name = "v";
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "serializeValue";
                                              }
                                            ];
                                            type = "variable";
                                          };
                                          type = "call";
                                        };
                                      }
                                    ];
                                    callee = {
                                      name = "v";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "mkVariant";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                              ];
                              type = "string";
                            };
                            form = "identifier";
                            parameters = [
                              {
                                default = null;
                                name = "key";
                                variadic = false;
                              }
                            ];
                            type = "lambda";
                          };
                        }
                      ];
                      callee = {
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "map";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                }
              ];
              type = "let";
            };
            "then" = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "@a{sv} {}";
                }
              ];
              type = "string";
            };
            type = "if";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "params";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "index";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "padId";
        type = "let-binding";
        value = {
          body = {
            body = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "effect_";
                }
                {
                  expression = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "zeros";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          type = "group";
                          value = {
                            left = {
                              kind = "integer";
                              type = "literal";
                              value = 12;
                            };
                            operator = "-";
                            right = {
                              arguments = [
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "str";
                                    }
                                  ];
                                  type = "reference";
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "stringLength";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "binary";
                          };
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            kind = "integer";
                            type = "literal";
                            value = 0;
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "substring";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                  type = "interpolation";
                }
                {
                  expression = {
                    path = [
                      {
                        kind = "identifier";
                        value = "str";
                      }
                    ];
                    type = "reference";
                  };
                  type = "interpolation";
                }
              ];
              type = "string";
            };
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "str";
                  }
                ];
                type = "assignment";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "index";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "toString";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "zeros";
                  }
                ];
                type = "assignment";
                value = {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "000000000000";
                    }
                  ];
                  type = "string";
                };
              }
            ];
            type = "let";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "index";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "effect";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "normalizeEffect";
        type = "let-binding";
        value = {
          body = {
            body = {
              body = {
                condition = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "effectAttrs";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    arguments = [
                      {
                        items = [
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "blur";
                              }
                            ];
                            type = "string";
                          }
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "gaussian";
                              }
                            ];
                            type = "string";
                          }
                        ];
                        type = "list";
                      }
                    ];
                    callee = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "hasAttrByPath";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                  type = "call";
                };
                "else" = {
                  condition = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "effectAttrs";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          items = [
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "blur";
                                }
                              ];
                              type = "string";
                            }
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "monte_carlo";
                                }
                              ];
                              type = "string";
                            }
                          ];
                          type = "list";
                        }
                      ];
                      callee = {
                        name = "lib";
                        path = [
                          {
                            kind = "identifier";
                            value = "hasAttrByPath";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                  "else" = {
                    condition = {
                      arguments = [
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "effectAttrs";
                            }
                          ];
                          type = "reference";
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "corner";
                              }
                            ];
                            type = "string";
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "hasAttr";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                    "else" = {
                      condition = {
                        arguments = [
                          {
                            path = [
                              {
                                kind = "identifier";
                                value = "effectAttrs";
                              }
                            ];
                            type = "reference";
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "noise";
                                }
                              ];
                              type = "string";
                            }
                          ];
                          callee = {
                            name = "lib";
                            path = [
                              {
                                kind = "identifier";
                                value = "hasAttr";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                        type = "call";
                      };
                      "else" = {
                        condition = {
                          arguments = [
                            {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "effectAttrs";
                                }
                              ];
                              type = "reference";
                            }
                          ];
                          callee = {
                            arguments = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "color";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            callee = {
                              name = "lib";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "hasAttr";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                          type = "call";
                        };
                        "else" = {
                          condition = {
                            arguments = [
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "effectAttrs";
                                  }
                                ];
                                type = "reference";
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "pixelize";
                                    }
                                  ];
                                  type = "string";
                                }
                              ];
                              callee = {
                                name = "lib";
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "hasAttr";
                                  }
                                ];
                                type = "variable";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                          "else" = {
                            condition = {
                              arguments = [
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "effectAttrs";
                                    }
                                  ];
                                  type = "reference";
                                }
                              ];
                              callee = {
                                arguments = [
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "derivative";
                                      }
                                    ];
                                    type = "string";
                                  }
                                ];
                                callee = {
                                  name = "lib";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "hasAttr";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                              type = "call";
                            };
                            "else" = {
                              condition = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "effectAttrs";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                callee = {
                                  arguments = [
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "type";
                                        }
                                      ];
                                      type = "string";
                                    }
                                  ];
                                  callee = {
                                    name = "lib";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "hasAttr";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "call";
                                };
                                type = "call";
                              };
                              "else" = {
                                arguments = [
                                  {
                                    recursive = false;
                                    statements = [ ];
                                    type = "attr-set";
                                  }
                                ];
                                callee = {
                                  arguments = [
                                    {
                                      multiline = false;
                                      parts = [
                                        {
                                          type = "text";
                                          value = "Unknown effect type in pipeline configuration";
                                        }
                                      ];
                                      type = "string";
                                    }
                                  ];
                                  callee = {
                                    arguments = [
                                      {
                                        kind = "false";
                                        type = "literal";
                                        value = false;
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "throwIfNot";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "call";
                                };
                                type = "call";
                              };
                              "then" = {
                                arguments = [
                                  {
                                    type = "group";
                                    value = {
                                      default = {
                                        recursive = false;
                                        statements = [ ];
                                        type = "attr-set";
                                      };
                                      type = "default";
                                      value = {
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "effectAttrs";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "params";
                                          }
                                        ];
                                        type = "reference";
                                      };
                                    };
                                  }
                                ];
                                callee = {
                                  arguments = [
                                    {
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "effectAttrs";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "type";
                                        }
                                      ];
                                      type = "reference";
                                    }
                                  ];
                                  callee = {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "process";
                                      }
                                    ];
                                    type = "reference";
                                  };
                                  type = "call";
                                };
                                type = "call";
                              };
                              type = "if";
                            };
                            "then" = {
                              arguments = [
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "effectAttrs";
                                    }
                                    {
                                      kind = "identifier";
                                      value = "derivative";
                                    }
                                  ];
                                  type = "reference";
                                }
                              ];
                              callee = {
                                arguments = [
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "derivative";
                                      }
                                    ];
                                    type = "string";
                                  }
                                ];
                                callee = {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "process";
                                    }
                                  ];
                                  type = "reference";
                                };
                                type = "call";
                              };
                              type = "call";
                            };
                            type = "if";
                          };
                          "then" = {
                            arguments = [
                              {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "effectAttrs";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "pixelize";
                                  }
                                ];
                                type = "reference";
                              }
                            ];
                            callee = {
                              arguments = [
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "pixelize";
                                    }
                                  ];
                                  type = "string";
                                }
                              ];
                              callee = {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "process";
                                  }
                                ];
                                type = "reference";
                              };
                              type = "call";
                            };
                            type = "call";
                          };
                          type = "if";
                        };
                        "then" = {
                          arguments = [
                            {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "effectAttrs";
                                }
                                {
                                  kind = "identifier";
                                  value = "color";
                                }
                              ];
                              type = "reference";
                            }
                          ];
                          callee = {
                            arguments = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "color";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            callee = {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "process";
                                }
                              ];
                              type = "reference";
                            };
                            type = "call";
                          };
                          type = "call";
                        };
                        type = "if";
                      };
                      "then" = {
                        arguments = [
                          {
                            path = [
                              {
                                kind = "identifier";
                                value = "effectAttrs";
                              }
                              {
                                kind = "identifier";
                                value = "noise";
                              }
                            ];
                            type = "reference";
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "noise";
                                }
                              ];
                              type = "string";
                            }
                          ];
                          callee = {
                            path = [
                              {
                                kind = "identifier";
                                value = "process";
                              }
                            ];
                            type = "reference";
                          };
                          type = "call";
                        };
                        type = "call";
                      };
                      type = "if";
                    };
                    "then" = {
                      arguments = [
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "effectAttrs";
                            }
                            {
                              kind = "identifier";
                              value = "corner";
                            }
                          ];
                          type = "reference";
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "corner";
                              }
                            ];
                            type = "string";
                          }
                        ];
                        callee = {
                          path = [
                            {
                              kind = "identifier";
                              value = "process";
                            }
                          ];
                          type = "reference";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                    type = "if";
                  };
                  "then" = {
                    arguments = [
                      {
                        type = "group";
                        value = {
                          arguments = [
                            {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "effectAttrs";
                                }
                              ];
                              type = "reference";
                            }
                          ];
                          callee = {
                            arguments = [
                              {
                                items = [
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "blur";
                                      }
                                    ];
                                    type = "string";
                                  }
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "monte_carlo";
                                      }
                                    ];
                                    type = "string";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "lib";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "getAttrFromPath";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                          type = "call";
                        };
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          multiline = false;
                          parts = [
                            {
                              type = "text";
                              value = "monte_carlo_blur";
                            }
                          ];
                          type = "string";
                        }
                      ];
                      callee = {
                        path = [
                          {
                            kind = "identifier";
                            value = "process";
                          }
                        ];
                        type = "reference";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                  type = "if";
                };
                "then" = {
                  arguments = [
                    {
                      type = "group";
                      value = {
                        arguments = [
                          {
                            path = [
                              {
                                kind = "identifier";
                                value = "effectAttrs";
                              }
                            ];
                            type = "reference";
                          }
                        ];
                        callee = {
                          arguments = [
                            {
                              items = [
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "blur";
                                    }
                                  ];
                                  type = "string";
                                }
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "gaussian";
                                    }
                                  ];
                                  type = "string";
                                }
                              ];
                              type = "list";
                            }
                          ];
                          callee = {
                            name = "lib";
                            path = [
                              {
                                kind = "identifier";
                                value = "getAttrFromPath";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                        type = "call";
                      };
                    }
                  ];
                  callee = {
                    arguments = [
                      {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "native_static_gaussian_blur";
                          }
                        ];
                        type = "string";
                      }
                    ];
                    callee = {
                      path = [
                        {
                          kind = "identifier";
                          value = "process";
                        }
                      ];
                      type = "reference";
                    };
                    type = "call";
                  };
                  type = "call";
                };
                type = "if";
              };
              statements = [
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "generatedId";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "index";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      name = "v";
                      path = [
                        {
                          kind = "identifier";
                          value = "padId";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "process";
                    }
                  ];
                  type = "assignment";
                  value = {
                    body = {
                      body = {
                        recursive = false;
                        statements = [
                          {
                            names = [
                              "type"
                              "params"
                            ];
                            source = null;
                            type = "inherit";
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "id";
                              }
                            ];
                            type = "assignment";
                            value = {
                              default = {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "generatedId";
                                  }
                                ];
                                type = "reference";
                              };
                              type = "default";
                              value = {
                                path = [
                                  {
                                    kind = "identifier";
                                    value = "effectAttrs";
                                  }
                                  {
                                    kind = "identifier";
                                    value = "id";
                                  }
                                ];
                                type = "reference";
                              };
                            };
                          }
                        ];
                        type = "attr-set";
                      };
                      form = "identifier";
                      parameters = [
                        {
                          default = null;
                          name = "params";
                          variadic = false;
                        }
                      ];
                      type = "lambda";
                    };
                    form = "identifier";
                    parameters = [
                      {
                        default = null;
                        name = "type";
                        variadic = false;
                      }
                    ];
                    type = "lambda";
                  };
                }
              ];
              type = "let";
            };
            form = "identifier";
            parameters = [
              {
                default = null;
                name = "effectAttrs";
                variadic = false;
              }
            ];
            type = "lambda";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "index";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "effect";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "serializeEffect";
        type = "let-binding";
        value = {
          body = {
            body = {
              body = {
                arguments = [
                  {
                    path = [
                      {
                        kind = "identifier";
                        value = "dict";
                      }
                    ];
                    type = "reference";
                  }
                ];
                callee = {
                  name = "v";
                  path = [
                    {
                      kind = "identifier";
                      value = "mkVariant";
                    }
                  ];
                  type = "variable";
                };
                type = "call";
              };
              statements = [
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "normalized";
                    }
                  ];
                  type = "assignment";
                  value = {
                    arguments = [
                      {
                        path = [
                          {
                            kind = "identifier";
                            value = "effectAttrs";
                          }
                        ];
                        type = "reference";
                      }
                    ];
                    callee = {
                      arguments = [
                        {
                          path = [
                            {
                              kind = "identifier";
                              value = "index";
                            }
                          ];
                          type = "reference";
                        }
                      ];
                      callee = {
                        name = "v";
                        path = [
                          {
                            kind = "identifier";
                            value = "normalizeEffect";
                          }
                        ];
                        type = "variable";
                      };
                      type = "call";
                    };
                    type = "call";
                  };
                }
                {
                  operator = "=";
                  target = [
                    {
                      kind = "identifier";
                      value = "dict";
                    }
                  ];
                  type = "assignment";
                  value = {
                    multiline = false;
                    parts = [
                      {
                        type = "text";
                        value = "{'type': ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "normalized";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "type";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                callee = {
                                  name = "v";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "mkString";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                            }
                          ];
                          callee = {
                            name = "v";
                            path = [
                              {
                                kind = "identifier";
                                value = "mkVariant";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = ", 'id': ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "normalized";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "id";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                callee = {
                                  name = "v";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "mkString";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                            }
                          ];
                          callee = {
                            name = "v";
                            path = [
                              {
                                kind = "identifier";
                                value = "mkVariant";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = ", 'params': ";
                      }
                      {
                        expression = {
                          arguments = [
                            {
                              type = "group";
                              value = {
                                arguments = [
                                  {
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "normalized";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "params";
                                      }
                                    ];
                                    type = "reference";
                                  }
                                ];
                                callee = {
                                  name = "v";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "serializeParams";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                            }
                          ];
                          callee = {
                            name = "v";
                            path = [
                              {
                                kind = "identifier";
                                value = "mkVariant";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                        type = "interpolation";
                      }
                      {
                        type = "text";
                        value = "}";
                      }
                    ];
                    type = "string";
                  };
                }
              ];
              type = "let";
            };
            form = "identifier";
            parameters = [
              {
                default = null;
                name = "effectAttrs";
                variadic = false;
              }
            ];
            type = "lambda";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "index";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          arguments = [
            {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "pipeline";
                }
              ];
              type = "string";
            }
          ];
          callee = {
            name = "type";
            path = [
              {
                kind = "identifier";
                value = "function";
              }
            ];
            type = "variable";
          };
          type = "call";
        };
        name = "serializePipeline";
        type = "let-binding";
        value = {
          body = {
            body = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "{'name': ";
                }
                {
                  expression = {
                    arguments = [
                      {
                        type = "group";
                        value = {
                          arguments = [
                            {
                              path = [
                                {
                                  kind = "identifier";
                                  value = "pipeline";
                                }
                                {
                                  kind = "identifier";
                                  value = "name";
                                }
                              ];
                              type = "reference";
                            }
                          ];
                          callee = {
                            name = "v";
                            path = [
                              {
                                kind = "identifier";
                                value = "mkString";
                              }
                            ];
                            type = "variable";
                          };
                          type = "call";
                        };
                      }
                    ];
                    callee = {
                      name = "v";
                      path = [
                        {
                          kind = "identifier";
                          value = "mkVariant";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                  type = "interpolation";
                }
                {
                  type = "text";
                  value = ", 'effects': ";
                }
                {
                  expression = {
                    arguments = [
                      {
                        multiline = false;
                        parts = [
                          {
                            type = "text";
                            value = "[";
                          }
                          {
                            expression = {
                              arguments = [
                                {
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "serializedEffects";
                                    }
                                  ];
                                  type = "reference";
                                }
                              ];
                              callee = {
                                arguments = [
                                  {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = ", ";
                                      }
                                    ];
                                    type = "string";
                                  }
                                ];
                                callee = {
                                  name = "lib";
                                  path = [
                                    {
                                      kind = "identifier";
                                      value = "concatStringsSep";
                                    }
                                  ];
                                  type = "variable";
                                };
                                type = "call";
                              };
                              type = "call";
                            };
                            type = "interpolation";
                          }
                          {
                            type = "text";
                            value = "]";
                          }
                        ];
                        type = "string";
                      }
                    ];
                    callee = {
                      name = "v";
                      path = [
                        {
                          kind = "identifier";
                          value = "mkVariant";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                  type = "interpolation";
                }
                {
                  type = "text";
                  value = "}";
                }
              ];
              type = "string";
            };
            statements = [
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "serializedEffects";
                  }
                ];
                type = "assignment";
                value = {
                  arguments = [
                    {
                      path = [
                        {
                          kind = "identifier";
                          value = "pipeline";
                        }
                        {
                          kind = "identifier";
                          value = "effects";
                        }
                      ];
                      type = "reference";
                    }
                  ];
                  callee = {
                    arguments = [
                      {
                        name = "v";
                        path = [
                          {
                            kind = "identifier";
                            value = "serializeEffect";
                          }
                        ];
                        type = "variable";
                      }
                    ];
                    callee = {
                      name = "lib";
                      path = [
                        {
                          kind = "identifier";
                          value = "imap0";
                        }
                      ];
                      type = "variable";
                    };
                    type = "call";
                  };
                  type = "call";
                };
              }
            ];
            type = "let";
          };
          form = "identifier";
          parameters = [
            {
              default = null;
              name = "pipeline";
              variadic = false;
            }
          ];
          type = "lambda";
        };
      }
      {
        annotation = {
          name = "type";
          path = [
            {
              kind = "identifier";
              value = "string";
            }
          ];
          type = "variable";
        };
        name = "pipelinesGVariant";
        type = "let-binding";
        value = {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "{";
            }
            {
              expression = {
                arguments = [
                  {
                    type = "group";
                    value = {
                      arguments = [
                        {
                          name = "path";
                          path = [
                            {
                              kind = "identifier";
                              value = "general";
                            }
                            {
                              kind = "identifier";
                              value = "pipelines";
                            }
                          ];
                          type = "variable";
                        }
                      ];
                      callee = {
                        arguments = [
                          {
                            type = "group";
                            value = {
                              body = {
                                body = {
                                  multiline = false;
                                  parts = [
                                    {
                                      expression = {
                                        arguments = [
                                          {
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "id";
                                              }
                                            ];
                                            type = "reference";
                                          }
                                        ];
                                        callee = {
                                          name = "v";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "mkString";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "call";
                                      };
                                      type = "interpolation";
                                    }
                                    {
                                      type = "text";
                                      value = ": ";
                                    }
                                    {
                                      expression = {
                                        arguments = [
                                          {
                                            path = [
                                              {
                                                kind = "identifier";
                                                value = "pipeline";
                                              }
                                            ];
                                            type = "reference";
                                          }
                                        ];
                                        callee = {
                                          name = "v";
                                          path = [
                                            {
                                              kind = "identifier";
                                              value = "serializePipeline";
                                            }
                                          ];
                                          type = "variable";
                                        };
                                        type = "call";
                                      };
                                      type = "interpolation";
                                    }
                                  ];
                                  type = "string";
                                };
                                form = "identifier";
                                parameters = [
                                  {
                                    default = null;
                                    name = "pipeline";
                                    variadic = false;
                                  }
                                ];
                                type = "lambda";
                              };
                              form = "identifier";
                              parameters = [
                                {
                                  default = null;
                                  name = "id";
                                  variadic = false;
                                }
                              ];
                              type = "lambda";
                            };
                          }
                        ];
                        callee = {
                          name = "lib";
                          path = [
                            {
                              kind = "identifier";
                              value = "mapAttrsToList";
                            }
                          ];
                          type = "variable";
                        };
                        type = "call";
                      };
                      type = "call";
                    };
                  }
                ];
                callee = {
                  arguments = [
                    {
                      multiline = false;
                      parts = [
                        {
                          type = "text";
                          value = ", ";
                        }
                      ];
                      type = "string";
                    }
                  ];
                  callee = {
                    name = "lib";
                    path = [
                      {
                        kind = "identifier";
                        value = "concatStringsSep";
                      }
                    ];
                    type = "variable";
                  };
                  type = "call";
                };
                type = "call";
              };
              type = "interpolation";
            }
            {
              type = "text";
              value = "}";
            }
          ];
          type = "string";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "enable";
          }
        ];
        type = "assignment";
        value = {
          body = {
            recursive = false;
            statements = [
              {
                body = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "settings";
                        }
                        {
                          kind = "string";
                          value = "org/gnome/shell";
                        }
                        {
                          kind = "identifier";
                          value = "enabled-extensions";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            name = "pkgs";
                            path = [
                              {
                                kind = "identifier";
                                value = "zenos";
                              }
                              {
                                kind = "identifier";
                                value = "legacy";
                              }
                              {
                                kind = "identifier";
                                value = "gnomeExtensions";
                              }
                              {
                                kind = "identifier";
                                value = "blur-my-shell";
                              }
                              {
                                kind = "identifier";
                                value = "extensionUuid";
                              }
                            ];
                            type = "variable";
                          }
                        ];
                        type = "list";
                      };
                    }
                  ];
                  type = "attr-set";
                };
                guards = [ ];
                scope = "user";
                type = "action";
                unconditional = false;
              }
              {
                operator = "=";
                target = [
                  {
                    kind = "identifier";
                    value = "_meta";
                  }
                ];
                type = "assignment";
                value = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "description";
                        }
                      ];
                      type = "assignment";
                      value = {
                        multiline = true;
                        parts = [
                          {
                            type = "text";
                            value = "Whether to enable Blur My Shell GNOME extension configuration.";
                          }
                        ];
                        type = "string";
                      };
                    }
                  ];
                  type = "attr-set";
                };
              }
              {
                body = {
                  recursive = false;
                  statements = [
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "environment";
                        }
                        {
                          kind = "identifier";
                          value = "systemPackages";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            name = "pkgs";
                            path = [
                              {
                                kind = "identifier";
                                value = "zenos";
                              }
                              {
                                kind = "identifier";
                                value = "legacy";
                              }
                              {
                                kind = "identifier";
                                value = "gnomeExtensions";
                              }
                              {
                                kind = "identifier";
                                value = "blur-my-shell";
                              }
                            ];
                            type = "variable";
                          }
                        ];
                        type = "list";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "programs";
                        }
                        {
                          kind = "identifier";
                          value = "dconf";
                        }
                        {
                          kind = "identifier";
                          value = "profiles";
                        }
                        {
                          kind = "identifier";
                          value = "user";
                        }
                        {
                          kind = "identifier";
                          value = "databases";
                        }
                      ];
                      type = "assignment";
                      value = {
                        items = [
                          {
                            recursive = false;
                            statements = [
                              {
                                operator = "=";
                                target = [
                                  {
                                    kind = "identifier";
                                    value = "settings";
                                  }
                                ];
                                type = "assignment";
                                value = {
                                  recursive = false;
                                  statements = [
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "settings-version";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "general";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "settings-version";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "general";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "general";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "general";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "general";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "general";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color-and-noise";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "general";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color-and-noise";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "hacks-level";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "general";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "hacks-level";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "debug";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "general";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "debug";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/overview";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "pipeline";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "pipeline";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "customize";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "customize";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "overview";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "overview";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "style-components";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "overview";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "style-components";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/appfolder";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appfolder";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "customize";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appfolder";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "customize";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "appfolder";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appfolder";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appfolder";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appfolder";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "appfolder";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "style-dialogs";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "appfolder";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "style-dialogs";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/panel";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "pipeline";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "pipeline";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "customize";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "customize";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "panel";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "static-blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "static-blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "unblur-in-overview";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "unblur-in-overview";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "force-light-text";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "force-light-text";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "override-background";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "override-background";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "style-panel";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "panel";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "style-panel";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "override-background-dynamically";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "panel";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "override-background-dynamically";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/dash-to-dock";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "pipeline";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "pipeline";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "customize";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "customize";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "dash-to-dock";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "static-blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "static-blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "override-background";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "override-background";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "style-dash-to-dock";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "dash-to-dock";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "style-dash-to-dock";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "unblur-in-overview";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "dash-to-dock";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "unblur-in-overview";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "corner-radius";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "dash-to-dock";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "corner-radius";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/applications";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "customize";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "customize";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "applications";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "opacity";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "applications";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "opacity";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "dynamic-opacity";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "dynamic-opacity";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur-on-overview";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur-on-overview";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "enable-all";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "applications";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "enable-all";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "whitelist";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              condition = {
                                                left = {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "applications";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "whitelist";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                operator = "==";
                                                right = {
                                                  items = [ ];
                                                  type = "list";
                                                };
                                                type = "binary";
                                              };
                                              "else" = {
                                                arguments = [
                                                  {
                                                    name = "path";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "applications";
                                                      }
                                                      {
                                                        kind = "identifier";
                                                        value = "whitelist";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  }
                                                ];
                                                callee = {
                                                  name = "lib";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "gvariant";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "mkArray";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                type = "call";
                                              };
                                              "then" = {
                                                arguments = [
                                                  {
                                                    name = "lib";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "gvariant";
                                                      }
                                                      {
                                                        kind = "identifier";
                                                        value = "type";
                                                      }
                                                      {
                                                        kind = "identifier";
                                                        value = "string";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  }
                                                ];
                                                callee = {
                                                  name = "lib";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "gvariant";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "mkEmptyArray";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                type = "call";
                                              };
                                              type = "if";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blacklist";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              condition = {
                                                left = {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "applications";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "blacklist";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                operator = "==";
                                                right = {
                                                  items = [ ];
                                                  type = "list";
                                                };
                                                type = "binary";
                                              };
                                              "else" = {
                                                arguments = [
                                                  {
                                                    name = "path";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "applications";
                                                      }
                                                      {
                                                        kind = "identifier";
                                                        value = "blacklist";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  }
                                                ];
                                                callee = {
                                                  name = "lib";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "gvariant";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "mkArray";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                type = "call";
                                              };
                                              "then" = {
                                                arguments = [
                                                  {
                                                    name = "lib";
                                                    path = [
                                                      {
                                                        kind = "identifier";
                                                        value = "gvariant";
                                                      }
                                                      {
                                                        kind = "identifier";
                                                        value = "type";
                                                      }
                                                      {
                                                        kind = "identifier";
                                                        value = "string";
                                                      }
                                                    ];
                                                    type = "variable";
                                                  }
                                                ];
                                                callee = {
                                                  name = "lib";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "gvariant";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "mkEmptyArray";
                                                    }
                                                  ];
                                                  type = "variable";
                                                };
                                                type = "call";
                                              };
                                              type = "if";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/screenshot";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "screenshot";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "pipeline";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "screenshot";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "pipeline";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "customize";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "screenshot";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "customize";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "screenshot";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "screenshot";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "screenshot";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "screenshot";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "screenshot";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/lockscreen";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "lockscreen";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "pipeline";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "lockscreen";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "pipeline";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "customize";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "lockscreen";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "customize";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "lockscreen";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "lockscreen";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "lockscreen";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "lockscreen";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "lockscreen";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/window-list";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "window-list";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "pipeline";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "window-list";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "pipeline";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "customize";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "window-list";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "customize";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "sigma";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              arguments = [
                                                {
                                                  name = "path";
                                                  path = [
                                                    {
                                                      kind = "identifier";
                                                      value = "window-list";
                                                    }
                                                    {
                                                      kind = "identifier";
                                                      value = "sigma";
                                                    }
                                                  ];
                                                  type = "variable";
                                                }
                                              ];
                                              callee = {
                                                name = "lib";
                                                path = [
                                                  {
                                                    kind = "identifier";
                                                    value = "gvariant";
                                                  }
                                                  {
                                                    kind = "identifier";
                                                    value = "mkInt32";
                                                  }
                                                ];
                                                type = "variable";
                                              };
                                              type = "call";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "brightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "window-list";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "brightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "color";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "window-list";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "color";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-amount";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "window-list";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-amount";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "noise-lightness";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "window-list";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "noise-lightness";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        recursive = false;
                                        statements = [
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "blur";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "coverflow-alt-tab";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "blur";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                          {
                                            operator = "=";
                                            target = [
                                              {
                                                kind = "identifier";
                                                value = "pipeline";
                                              }
                                            ];
                                            type = "assignment";
                                            value = {
                                              name = "path";
                                              path = [
                                                {
                                                  kind = "identifier";
                                                  value = "coverflow-alt-tab";
                                                }
                                                {
                                                  kind = "identifier";
                                                  value = "pipeline";
                                                }
                                              ];
                                              type = "variable";
                                            };
                                          }
                                        ];
                                        type = "attr-set";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/hidetopbar";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "compatibility";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "hidetopbar";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "compatibility";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    }
                                    {
                                      operator = "=";
                                      target = [
                                        {
                                          kind = "string";
                                          value = "org/gnome/shell/extensions/blur-my-shell/dash-to-panel";
                                        }
                                        {
                                          kind = "identifier";
                                          value = "blur-original-panel";
                                        }
                                      ];
                                      type = "assignment";
                                      value = {
                                        name = "path";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "dash-to-panel";
                                          }
                                          {
                                            kind = "identifier";
                                            value = "blur-original-panel";
                                          }
                                        ];
                                        type = "variable";
                                      };
                                    }
                                  ];
                                  type = "attr-set";
                                };
                              }
                            ];
                            type = "attr-set";
                          }
                        ];
                        type = "list";
                      };
                    }
                    {
                      operator = "=";
                      target = [
                        {
                          kind = "identifier";
                          value = "systemd";
                        }
                        {
                          kind = "identifier";
                          value = "user";
                        }
                        {
                          kind = "identifier";
                          value = "services";
                        }
                        {
                          kind = "identifier";
                          value = "blur-my-shell-pipelines";
                        }
                      ];
                      type = "assignment";
                      value = {
                        recursive = false;
                        statements = [
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "description";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = false;
                              parts = [
                                {
                                  type = "text";
                                  value = "Apply Blur My Shell pipelines configuration";
                                }
                              ];
                              type = "string";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "wantedBy";
                              }
                            ];
                            type = "assignment";
                            value = {
                              items = [
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "graphical-session.target";
                                    }
                                  ];
                                  type = "string";
                                }
                              ];
                              type = "list";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "partOf";
                              }
                            ];
                            type = "assignment";
                            value = {
                              items = [
                                {
                                  multiline = false;
                                  parts = [
                                    {
                                      type = "text";
                                      value = "graphical-session.target";
                                    }
                                  ];
                                  type = "string";
                                }
                              ];
                              type = "list";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "serviceConfig";
                              }
                            ];
                            type = "assignment";
                            value = {
                              recursive = false;
                              statements = [
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "Type";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    multiline = false;
                                    parts = [
                                      {
                                        type = "text";
                                        value = "oneshot";
                                      }
                                    ];
                                    type = "string";
                                  };
                                }
                                {
                                  operator = "=";
                                  target = [
                                    {
                                      kind = "identifier";
                                      value = "RemainAfterExit";
                                    }
                                  ];
                                  type = "assignment";
                                  value = {
                                    kind = "true";
                                    type = "literal";
                                    value = true;
                                  };
                                }
                              ];
                              type = "attr-set";
                            };
                          }
                          {
                            operator = "=";
                            target = [
                              {
                                kind = "identifier";
                                value = "script";
                              }
                            ];
                            type = "assignment";
                            value = {
                              multiline = true;
                              parts = [
                                {
                                  type = "text";
                                  value = "\n          ";
                                }
                                {
                                  expression = {
                                    name = "pkgs";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "zenos";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "legacy";
                                      }
                                      {
                                        kind = "identifier";
                                        value = "dconf";
                                      }
                                    ];
                                    type = "variable";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "/bin/dconf write /org/gnome/shell/extensions/blur-my-shell/pipelines ";
                                }
                                {
                                  expression = {
                                    arguments = [
                                      {
                                        name = "v";
                                        path = [
                                          {
                                            kind = "identifier";
                                            value = "pipelinesGVariant";
                                          }
                                        ];
                                        type = "variable";
                                      }
                                    ];
                                    callee = {
                                      name = "lib";
                                      path = [
                                        {
                                          kind = "identifier";
                                          value = "escapeShellArg";
                                        }
                                      ];
                                      type = "variable";
                                    };
                                    type = "call";
                                  };
                                  type = "interpolation";
                                }
                                {
                                  type = "text";
                                  value = "\n        ";
                                }
                              ];
                              type = "string";
                            };
                          }
                        ];
                        type = "attr-set";
                      };
                    }
                  ];
                  type = "attr-set";
                };
                guards = [ ];
                scope = "system";
                type = "action";
                unconditional = false;
              }
            ];
            type = "attr-set";
          };
          type = "enable-option";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "general";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "settings-version";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 1;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Internal version tracker for settings";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Global gaussian sigma (blur radius)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.6;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Global brightness adjustment for blur";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Global color mix (GVariant tuple)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Global film grain/noise intensity";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Global noise lightness adjustment";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color-and-noise";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Apply color and noise filters globally";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "hacks-level";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 1;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Performance/Compatibility hack level (0-2)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "debug";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Enable verbose console output for debugging";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pipelines";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "set";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "set";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            recursive = false;
                            statements = [ ];
                            type = "attr-set";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Advanced effect pipeline definitions";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "overview";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to activate blur for this component";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "customize";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to customize sigma/brightness or use global values";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Gaussian sigma (blur strength)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.6;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Brightness of the blur effect";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Color to mix with the blur (GVariant tuple string)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Amount of noise to add";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Lightness of the noise";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pipeline";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "pipeline_default";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Pipeline applied to the overview background";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "style-components";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 1;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Component transparency style (0-3)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "appfolder";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to activate blur for this component";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "customize";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to customize sigma/brightness or use global values";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Gaussian sigma (blur strength)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.6;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Brightness of the blur effect";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Color to mix with the blur (GVariant tuple string)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Amount of noise to add";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Lightness of the noise";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "style-dialogs";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 1;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Folder dialog visual style (0-3)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "panel";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to activate blur for this component";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "customize";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to customize sigma/brightness or use global values";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Gaussian sigma (blur strength)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.6;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Brightness of the blur effect";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Color to mix with the blur (GVariant tuple string)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Amount of noise to add";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Lightness of the noise";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pipeline";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "pipeline_default";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Pipeline applied to the panel";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "static-blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Use static image blur instead of live blur";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "unblur-in-overview";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Disable blur when entering the overview";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "force-light-text";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Force white text on blurred panel";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "override-background";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Force panel background override";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "style-panel";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Panel transparency style (0-3)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "override-background-dynamically";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Toggle blur based on window overlap";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "dash-to-dock";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to activate blur for this component";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "customize";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to customize sigma/brightness or use global values";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Gaussian sigma (blur strength)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.6;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Brightness of the blur effect";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Color to mix with the blur (GVariant tuple string)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Amount of noise to add";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Lightness of the noise";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pipeline";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "pipeline_default_rounded";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Pipeline applied to the dock";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "static-blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Use static blur for the dock";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "override-background";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Override dock background settings";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "style-dash-to-dock";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Dock transparency style (0-2)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "unblur-in-overview";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Disable blur in activity overview";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "corner-radius";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 12;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Corner rounding radius for the blur actor";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "applications";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to activate blur for this component";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "customize";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to customize sigma/brightness or use global values";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Gaussian sigma (blur strength)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 1.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Brightness of the blur effect";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Color to mix with the blur (GVariant tuple string)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Amount of noise to add";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Lightness of the noise";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "opacity";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 215;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Alpha opacity for blurred windows";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "dynamic-opacity";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Restore full opacity on window focus";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur-on-overview";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Keep window blur active in overview";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "enable-all";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Attempt to blur all window actors";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "whitelist";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [ ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "App IDs to explicitly include in blur";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blacklist";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            arguments = [
                              {
                                items = [
                                  {
                                    name = "type";
                                    path = [
                                      {
                                        kind = "identifier";
                                        value = "string";
                                      }
                                    ];
                                    type = "variable";
                                  }
                                ];
                                type = "list";
                              }
                            ];
                            callee = {
                              name = "type";
                              path = [
                                {
                                  kind = "identifier";
                                  value = "list";
                                }
                              ];
                              type = "variable";
                            };
                            type = "call";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            items = [
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "Plank";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "com.desktop.ding";
                                  }
                                ];
                                type = "string";
                              }
                              {
                                multiline = false;
                                parts = [
                                  {
                                    type = "text";
                                    value = "Conky";
                                  }
                                ];
                                type = "string";
                              }
                            ];
                            type = "list";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "App IDs to explicitly exclude from blur";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "screenshot";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to activate blur for this component";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "customize";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to customize sigma/brightness or use global values";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Gaussian sigma (blur strength)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.6;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Brightness of the blur effect";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Color to mix with the blur (GVariant tuple string)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Amount of noise to add";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Lightness of the noise";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pipeline";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "pipeline_default";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Pipeline for the screenshot interface";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "lockscreen";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to activate blur for this component";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "customize";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to customize sigma/brightness or use global values";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Gaussian sigma (blur strength)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.6;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Brightness of the blur effect";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Color to mix with the blur (GVariant tuple string)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Amount of noise to add";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Lightness of the noise";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pipeline";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "pipeline_default";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Pipeline for the lockscreen background";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "window-list";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to activate blur for this component";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "customize";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Whether to customize sigma/brightness or use global values";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "sigma";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "int";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "integer";
                            type = "literal";
                            value = 30;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Gaussian sigma (blur strength)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "brightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.6;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Brightness of the blur effect";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "color";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "(0.0,0.0,0.0,0.0)";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Color to mix with the blur (GVariant tuple string)";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-amount";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Amount of noise to add";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "noise-lightness";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "float";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "float";
                            type = "literal";
                            value = 0.0;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Lightness of the noise";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pipeline";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "pipeline_default";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Pipeline for the window list bar";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "coverflow-alt-tab";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Enable blur for coverflow switcher";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "pipeline";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "string";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = false;
                            parts = [
                              {
                                type = "text";
                                value = "pipeline_default";
                              }
                            ];
                            type = "string";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Pipeline for the coverflow background";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "hidetopbar";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "compatibility";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "false";
                            type = "literal";
                            value = false;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Toggle compatibility hacks for Hide Top Bar";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
      {
        operator = "=";
        target = [
          {
            kind = "identifier";
            value = "dash-to-panel";
          }
        ];
        type = "assignment";
        value = {
          recursive = false;
          statements = [
            {
              operator = "=";
              target = [
                {
                  kind = "identifier";
                  value = "blur-original-panel";
                }
              ];
              type = "assignment";
              value = {
                recursive = false;
                statements = [
                  {
                    operator = "=";
                    target = [
                      {
                        kind = "identifier";
                        value = "_meta";
                      }
                    ];
                    type = "assignment";
                    value = {
                      recursive = false;
                      statements = [
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "type";
                            }
                          ];
                          type = "assignment";
                          value = {
                            name = "type";
                            path = [
                              {
                                kind = "identifier";
                                value = "bool";
                              }
                            ];
                            type = "variable";
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "default";
                            }
                          ];
                          type = "assignment";
                          value = {
                            kind = "true";
                            type = "literal";
                            value = true;
                          };
                        }
                        {
                          operator = "=";
                          target = [
                            {
                              kind = "identifier";
                              value = "description";
                            }
                          ];
                          type = "assignment";
                          value = {
                            multiline = true;
                            parts = [
                              {
                                type = "text";
                                value = "Blur the Dash to Panel actor";
                              }
                            ];
                            type = "string";
                          };
                        }
                      ];
                      type = "attr-set";
                    };
                  }
                ];
                type = "attr-set";
              };
            }
          ];
          type = "attr-set";
        };
      }
    ];
  }; }
    (let mkVariant = (builtins.addErrorContext "_let mkVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: "<${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:22: string interpolation requires a scalar, path, or package") (value))}>"); } ]; }).config.value))); mkString = (builtins.addErrorContext "_let mkString annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:23: string interpolation requires a scalar, path, or package") (value))}'"); } ]; }).config.value))); mkFloat = (builtins.addErrorContext "_let mkFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
  str = (lib.toString value);
in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:24: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value))); serializeValue = (builtins.addErrorContext "_let serializeValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if (lib.isBool value) then ((if value then "true" else "false")) else (if (lib.isInt value) then (lib.toString value) else (if (lib.isFloat value) then (mkFloat value) else (if (lib.isString value) then (mkString value) else (((lib.throwIfNot false) "Unsupported type in pipeline params: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:30: string interpolation requires a scalar, path, or package") ((lib.typeOf value)))}") "")))))); } ]; }).config.value))); serializeParams = (builtins.addErrorContext "_let serializeParams annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (params: (if (params == { }) then "@a{sv} {}" else (let
  keys = ((lib.sort ((a: (b: (a < b))))) ((lib.attrNames params)));
  pairs = ((lib.map ((key: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:36: string interpolation requires a scalar, path, or package") ((mkString key)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:36: string interpolation requires a scalar, path, or package") ((mkVariant ((serializeValue (((lib.getAttr key) params)))))))}"))) keys);
in "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:37: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") pairs)))}}"))); } ]; }).config.value))); padId = (builtins.addErrorContext "_let padId annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:38:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (let
  str = (lib.toString index);
  zeros = "000000000000";
in "effect_${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:42: string interpolation requires a scalar, path, or package") ((((lib.substring 0) ((12 - (lib.stringLength str)))) zeros)))}${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:42: string interpolation requires a scalar, path, or package") (str))}")); } ]; }).config.value))); normalizeEffect = (builtins.addErrorContext "_let normalizeEffect annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:43:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (effectAttrs: (let
  generatedId = (padId index);
  process = (type: (params: {
    inherit type params;
    id = (effectAttrs.id or generatedId);
  }));
in (if ((lib.hasAttrByPath [
  "blur"
  "gaussian"
]) effectAttrs) then ((process "native_static_gaussian_blur") (((lib.getAttrFromPath [
  "blur"
  "gaussian"
]) effectAttrs))) else (if ((lib.hasAttrByPath [
  "blur"
  "monte_carlo"
]) effectAttrs) then ((process "monte_carlo_blur") (((lib.getAttrFromPath [
  "blur"
  "monte_carlo"
]) effectAttrs))) else (if ((lib.hasAttr "corner") effectAttrs) then ((process "corner") effectAttrs.corner) else (if ((lib.hasAttr "noise") effectAttrs) then ((process "noise") effectAttrs.noise) else (if ((lib.hasAttr "color") effectAttrs) then ((process "color") effectAttrs.color) else (if ((lib.hasAttr "pixelize") effectAttrs) then ((process "pixelize") effectAttrs.pixelize) else (if ((lib.hasAttr "derivative") effectAttrs) then ((process "derivative") effectAttrs.derivative) else (if ((lib.hasAttr "type") effectAttrs) then ((process effectAttrs.type) ((effectAttrs.params or { }))) else (((lib.throwIfNot false) "Unknown effect type in pipeline configuration") { })))))))))))); } ]; }).config.value))); serializeEffect = (builtins.addErrorContext "_let serializeEffect annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:56:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (effectAttrs: (let
  normalized = ((normalizeEffect index) effectAttrs);
  dict = "{'type': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString normalized.type)))))}, 'id': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString normalized.id)))))}, 'params': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((serializeParams normalized.params)))))}}";
in (mkVariant dict)))); } ]; }).config.value))); serializePipeline = (builtins.addErrorContext "_let serializePipeline annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:61:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (pipeline: (let
  serializedEffects = ((lib.imap0 serializeEffect) pipeline.effects);
in "{'name': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString pipeline.name)))))}, 'effects': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") ((mkVariant "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") serializedEffects)))}]")))}}")); } ]; }).config.value))); pipelinesGVariant = (builtins.addErrorContext "_let pipelinesGVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.mapAttrsToList ((id: (pipeline: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") ((mkString id)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") ((serializePipeline pipeline)))}")))) cfg.general.pipelines)))))}}"; } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) { home-manager.sharedModules = [ {
      dconf.settings."org/gnome/shell".enabled-extensions = [
        pkgs.zenos.legacy.gnomeExtensions.blur-my-shell.extensionUuid
      ];
    } ]; }))
    (let mkVariant = (builtins.addErrorContext "_let mkVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:22:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: "<${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:22: string interpolation requires a scalar, path, or package") (value))}>"); } ]; }).config.value))); mkString = (builtins.addErrorContext "_let mkString annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:23:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: "'${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:23: string interpolation requires a scalar, path, or package") (value))}'"); } ]; }).config.value))); mkFloat = (builtins.addErrorContext "_let mkFloat annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:24:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (let
  str = (lib.toString value);
in (if ((lib.hasInfix ".") str) then str else "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:24: string interpolation requires a scalar, path, or package") (str))}.0"))); } ]; }).config.value))); serializeValue = (builtins.addErrorContext "_let serializeValue annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:25:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (value: (if (lib.isBool value) then ((if value then "true" else "false")) else (if (lib.isInt value) then (lib.toString value) else (if (lib.isFloat value) then (mkFloat value) else (if (lib.isString value) then (mkString value) else (((lib.throwIfNot false) "Unsupported type in pipeline params: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:30: string interpolation requires a scalar, path, or package") ((lib.typeOf value)))}") "")))))); } ]; }).config.value))); serializeParams = (builtins.addErrorContext "_let serializeParams annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:31:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (params: (if (params == { }) then "@a{sv} {}" else (let
  keys = ((lib.sort ((a: (b: (a < b))))) ((lib.attrNames params)));
  pairs = ((lib.map ((key: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:36: string interpolation requires a scalar, path, or package") ((mkString key)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:36: string interpolation requires a scalar, path, or package") ((mkVariant ((serializeValue (((lib.getAttr key) params)))))))}"))) keys);
in "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:37: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") pairs)))}}"))); } ]; }).config.value))); padId = (builtins.addErrorContext "_let padId annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:38:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (let
  str = (lib.toString index);
  zeros = "000000000000";
in "effect_${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:42: string interpolation requires a scalar, path, or package") ((((lib.substring 0) ((12 - (lib.stringLength str)))) zeros)))}${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:42: string interpolation requires a scalar, path, or package") (str))}")); } ]; }).config.value))); normalizeEffect = (builtins.addErrorContext "_let normalizeEffect annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:43:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (effectAttrs: (let
  generatedId = (padId index);
  process = (type: (params: {
    inherit type params;
    id = (effectAttrs.id or generatedId);
  }));
in (if ((lib.hasAttrByPath [
  "blur"
  "gaussian"
]) effectAttrs) then ((process "native_static_gaussian_blur") (((lib.getAttrFromPath [
  "blur"
  "gaussian"
]) effectAttrs))) else (if ((lib.hasAttrByPath [
  "blur"
  "monte_carlo"
]) effectAttrs) then ((process "monte_carlo_blur") (((lib.getAttrFromPath [
  "blur"
  "monte_carlo"
]) effectAttrs))) else (if ((lib.hasAttr "corner") effectAttrs) then ((process "corner") effectAttrs.corner) else (if ((lib.hasAttr "noise") effectAttrs) then ((process "noise") effectAttrs.noise) else (if ((lib.hasAttr "color") effectAttrs) then ((process "color") effectAttrs.color) else (if ((lib.hasAttr "pixelize") effectAttrs) then ((process "pixelize") effectAttrs.pixelize) else (if ((lib.hasAttr "derivative") effectAttrs) then ((process "derivative") effectAttrs.derivative) else (if ((lib.hasAttr "type") effectAttrs) then ((process effectAttrs.type) ((effectAttrs.params or { }))) else (((lib.throwIfNot false) "Unknown effect type in pipeline configuration") { })))))))))))); } ]; }).config.value))); serializeEffect = (builtins.addErrorContext "_let serializeEffect annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:56:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (index: (effectAttrs: (let
  normalized = ((normalizeEffect index) effectAttrs);
  dict = "{'type': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString normalized.type)))))}, 'id': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString normalized.id)))))}, 'params': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:59: string interpolation requires a scalar, path, or package") ((mkVariant ((serializeParams normalized.params)))))}}";
in (mkVariant dict)))); } ]; }).config.value))); serializePipeline = (builtins.addErrorContext "_let serializePipeline annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:61:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) ((lib.types.addCheck lib.types.unspecified builtins.isFunction)) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = (lib.types.addCheck lib.types.unspecified builtins.isFunction); }; config.value = (pipeline: (let
  serializedEffects = ((lib.imap0 serializeEffect) pipeline.effects);
in "{'name': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") ((mkVariant ((mkString pipeline.name)))))}, 'effects': ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") ((mkVariant "[${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:63: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") serializedEffects)))}]")))}}")); } ]; }).config.value))); pipelinesGVariant = (builtins.addErrorContext "_let pipelinesGVariant annotation mismatch: /nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64:1" ((_zenType: _zenValue: let force = type: value: if type.name == "anything" then true else if type.name == "listOf" then builtins.all (force type.nestedTypes.elemType) value else if type.name == "attrsOf" then builtins.all (force type.nestedTypes.elemType) (builtins.attrValues value) else if type.name == "either" then force (if type.nestedTypes.left.check value then type.nestedTypes.left else type.nestedTypes.right) value else builtins.seq value true; in builtins.seq (force _zenType _zenValue) _zenValue) (lib.types.str) ((lib.evalModules { modules = [ { options.value = lib.mkOption { type = lib.types.str; }; config.value = "{${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") (((lib.concatStringsSep ", ") (((lib.mapAttrsToList ((id: (pipeline: "${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") ((mkString id)))}: ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:64: string interpolation requires a scalar, path, or package") ((serializePipeline pipeline)))}")))) cfg.general.pipelines)))))}}"; } ]; }).config.value))); in (lib.mkIf ((cfg.enable)) {
      environment.systemPackages = [
        pkgs.zenos.legacy.gnomeExtensions.blur-my-shell
      ];
      programs.dconf.profiles.user.databases = [
        {
          settings = {
            "org/gnome/shell/extensions/blur-my-shell" = {
              settings-version = (lib.gvariant.mkInt32 cfg.general.settings-version);
              sigma = (lib.gvariant.mkInt32 cfg.general.sigma);
              brightness = cfg.general.brightness;
              color = cfg.general.color;
              noise-amount = cfg.general.noise-amount;
              noise-lightness = cfg.general.noise-lightness;
              color-and-noise = cfg.general.color-and-noise;
              hacks-level = (lib.gvariant.mkInt32 cfg.general.hacks-level);
              debug = cfg.general.debug;
            };
            "org/gnome/shell/extensions/blur-my-shell/overview" = {
              blur = cfg.overview.blur;
              pipeline = cfg.overview.pipeline;
              customize = cfg.overview.customize;
              sigma = (lib.gvariant.mkInt32 cfg.overview.sigma);
              brightness = cfg.overview.brightness;
              color = cfg.overview.color;
              noise-amount = cfg.overview.noise-amount;
              noise-lightness = cfg.overview.noise-lightness;
              style-components = (lib.gvariant.mkInt32 cfg.overview.style-components);
            };
            "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
              blur = cfg.appfolder.blur;
              customize = cfg.appfolder.customize;
              sigma = (lib.gvariant.mkInt32 cfg.appfolder.sigma);
              brightness = cfg.appfolder.brightness;
              color = cfg.appfolder.color;
              noise-amount = cfg.appfolder.noise-amount;
              noise-lightness = cfg.appfolder.noise-lightness;
              style-dialogs = (lib.gvariant.mkInt32 cfg.appfolder.style-dialogs);
            };
            "org/gnome/shell/extensions/blur-my-shell/panel" = {
              blur = cfg.panel.blur;
              pipeline = cfg.panel.pipeline;
              customize = cfg.panel.customize;
              sigma = (lib.gvariant.mkInt32 cfg.panel.sigma);
              brightness = cfg.panel.brightness;
              color = cfg.panel.color;
              noise-amount = cfg.panel.noise-amount;
              noise-lightness = cfg.panel.noise-lightness;
              static-blur = cfg.panel.static-blur;
              unblur-in-overview = cfg.panel.unblur-in-overview;
              force-light-text = cfg.panel.force-light-text;
              override-background = cfg.panel.override-background;
              style-panel = (lib.gvariant.mkInt32 cfg.panel.style-panel);
              override-background-dynamically = cfg.panel.override-background-dynamically;
            };
            "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
              blur = cfg.dash-to-dock.blur;
              pipeline = cfg.dash-to-dock.pipeline;
              customize = cfg.dash-to-dock.customize;
              sigma = (lib.gvariant.mkInt32 cfg.dash-to-dock.sigma);
              brightness = cfg.dash-to-dock.brightness;
              color = cfg.dash-to-dock.color;
              noise-amount = cfg.dash-to-dock.noise-amount;
              noise-lightness = cfg.dash-to-dock.noise-lightness;
              static-blur = cfg.dash-to-dock.static-blur;
              override-background = cfg.dash-to-dock.override-background;
              style-dash-to-dock = (lib.gvariant.mkInt32 cfg.dash-to-dock.style-dash-to-dock);
              unblur-in-overview = cfg.dash-to-dock.unblur-in-overview;
              corner-radius = (lib.gvariant.mkInt32 cfg.dash-to-dock.corner-radius);
            };
            "org/gnome/shell/extensions/blur-my-shell/applications" = {
              blur = cfg.applications.blur;
              customize = cfg.applications.customize;
              sigma = (lib.gvariant.mkInt32 cfg.applications.sigma);
              brightness = cfg.applications.brightness;
              color = cfg.applications.color;
              noise-amount = cfg.applications.noise-amount;
              noise-lightness = cfg.applications.noise-lightness;
              opacity = (lib.gvariant.mkInt32 cfg.applications.opacity);
              dynamic-opacity = cfg.applications.dynamic-opacity;
              blur-on-overview = cfg.applications.blur-on-overview;
              enable-all = cfg.applications.enable-all;
              whitelist = (if (cfg.applications.whitelist == [ ]) then (lib.gvariant.mkEmptyArray lib.gvariant.type.string) else (lib.gvariant.mkArray cfg.applications.whitelist));
              blacklist = (if (cfg.applications.blacklist == [ ]) then (lib.gvariant.mkEmptyArray lib.gvariant.type.string) else (lib.gvariant.mkArray cfg.applications.blacklist));
            };
            "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
              blur = cfg.screenshot.blur;
              pipeline = cfg.screenshot.pipeline;
              customize = cfg.screenshot.customize;
              sigma = (lib.gvariant.mkInt32 cfg.screenshot.sigma);
              brightness = cfg.screenshot.brightness;
              color = cfg.screenshot.color;
              noise-amount = cfg.screenshot.noise-amount;
              noise-lightness = cfg.screenshot.noise-lightness;
            };
            "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
              blur = cfg.lockscreen.blur;
              pipeline = cfg.lockscreen.pipeline;
              customize = cfg.lockscreen.customize;
              sigma = (lib.gvariant.mkInt32 cfg.lockscreen.sigma);
              brightness = cfg.lockscreen.brightness;
              color = cfg.lockscreen.color;
              noise-amount = cfg.lockscreen.noise-amount;
              noise-lightness = cfg.lockscreen.noise-lightness;
            };
            "org/gnome/shell/extensions/blur-my-shell/window-list" = {
              blur = cfg.window-list.blur;
              pipeline = cfg.window-list.pipeline;
              customize = cfg.window-list.customize;
              sigma = (lib.gvariant.mkInt32 cfg.window-list.sigma);
              brightness = cfg.window-list.brightness;
              color = cfg.window-list.color;
              noise-amount = cfg.window-list.noise-amount;
              noise-lightness = cfg.window-list.noise-lightness;
            };
            "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
              blur = cfg.coverflow-alt-tab.blur;
              pipeline = cfg.coverflow-alt-tab.pipeline;
            };
            "org/gnome/shell/extensions/blur-my-shell/hidetopbar".compatibility = cfg.hidetopbar.compatibility;
            "org/gnome/shell/extensions/blur-my-shell/dash-to-panel".blur-original-panel = cfg.dash-to-panel.blur-original-panel;
          };
        }
      ];
      systemd.user.services.blur-my-shell-pipelines = {
        description = "Apply Blur My Shell pipelines configuration";
        wantedBy = [
          "graphical-session.target"
        ];
        partOf = [
          "graphical-session.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = "\n          ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:197: string interpolation requires a scalar, path, or package") (pkgs.zenos.legacy.dconf))}/bin/dconf write /org/gnome/shell/extensions/blur-my-shell/pipelines ${((value: let kind = builtins.typeOf value; in if kind == "string" then value else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value else if kind == "path" then "${value}" else if kind == "set" && (value.type or null) == "derivation" && builtins.isString (value.outPath or null) then value.outPath else throw "/nix/store/59qqzf108ga8h2qmsjizzsn2p7i889xx-zenpkgs-dsl-source/modules/desktops/gnome/extensions/blur-my-shell.zmdl:197: string interpolation requires a scalar, path, or package") ((lib.escapeShellArg pipelinesGVariant)))}\n        ";
      };
    }))
  ];
}
