# Trusted executable backend; interface descriptors never call this function.
{ lib, pkgs }:
{ provider, metadata ? { }, dependenciesDeclared ? metadata ? dependencies }:
let
  fail = reason: throw "ZPKG dependency replacement: ${reason}";
  forceMetadata = value:
    if builtins.isAttrs value && (value.type or null) == "derivation" then builtins.seq value.outPath true
    else if builtins.isAttrs value then builtins.all forceMetadata (builtins.attrValues value)
    else if builtins.isList value then builtins.all forceMetadata value
    else builtins.seq value true;
  dependencyChannels = [
    "nativeBuildInputs" "buildInputs" "propagatedNativeBuildInputs" "propagatedBuildInputs"
    "checkInputs" "nativeCheckInputs" "installCheckInputs" "nativeInstallCheckInputs"
    "depsBuildBuild" "depsBuildBuildPropagated" "depsBuildTarget" "depsBuildTargetPropagated"
    "depsHostHost" "depsHostHostPropagated" "depsTargetTarget" "depsTargetTargetPropagated"
  ];
  scopes = { general = [ ]; build = [ ]; runtime = [ ]; } // (metadata.dependencies or { });
  declared = scopes.general ++ scopes.build ++ scopes.runtime;
  runtime = lib.unique (scopes.general ++ scopes.runtime);
  stdenv = provider.stdenv;
  native = env:
    env.buildPlatform == env.hostPlatform && env.hostPlatform == env.targetPlatform;
  single = package: (package.outputs or [ "out" ]) == [ "out" ];
  discardsReferences = attrs:
    let discard = attrs.unsafeDiscardReferences or false;
    in if builtins.isAttrs discard then lib.any (flag: flag != false) (builtins.attrValues discard)
      else discard != false;
  specialOutputs = attrs:
    (attrs.outputHash or null) != null || (attrs.__contentAddressed or false);
  original = provider.drvAttrs;
  oldInputs = lib.unique (lib.concatMap (name: original.${name} or [ ]) dependencyChannels);
  # Untracked strings are used only as comparison keys, never builder values.
  inputPath = input: builtins.unsafeDiscardStringContext (toString input);
  buildInputs = scopes.general ++ scopes.build;
  removed = lib.filter (input: !(builtins.elem (inputPath input) (map inputPath buildInputs))) oldInputs;
  runtimeOnly = lib.filter (input: !(builtins.elem (inputPath input) (map inputPath buildInputs))) scopes.runtime;
  forbiddenInputs = lib.unique (removed ++ runtimeOnly);

  # Override recipe-owned channels, not stdenv's implicit compiler/setup inputs.
  replaced = provider.overrideAttrs (_: lib.genAttrs dependencyChannels (_: [ ]) // {
    nativeBuildInputs = scopes.build;
    buildInputs = scopes.general;
  });
  probe = stdenv.mkDerivation { name = "zpkg-native-backend-probe"; };

  # Inspect final builder attributes after overrideAttrs has reevaluated recursive
  # recipes. Contexts catch captured interpolations without rewriting arbitrary
  # scripts; literal path checks also diagnose deliberately untracked references.
  references = value:
    if builtins.isString value then
      lib.any (input:
        builtins.hasAttr (builtins.unsafeDiscardStringContext (input.drvPath or "<no-derivation>")) (builtins.getContext value)
        || builtins.hasAttr (inputPath input) (builtins.getContext value)
        || lib.hasInfix (inputPath input) value
      ) forbiddenInputs
    else if builtins.isPath value || lib.isDerivation value then references (toString value)
    else if builtins.isList value then lib.any references value
    else if builtins.isAttrs value then lib.any references (builtins.attrValues value)
    else false;
  capturedFields = builtins.filter (name: references application.drvAttrs.${name})
    (builtins.attrNames (builtins.removeAttrs application.drvAttrs [
      "stdenv" "src" "srcs" "allowedReferences" "disallowedReferences"
      "allowedRequisites" "disallowedRequisites" "outputChecks"
    ]));
  contextKeys = value: builtins.attrNames (builtins.getContext (builtins.toJSON value));
  knownContexts = contextKeys [ probe.drvAttrs buildInputs
    (original.src or null) (original.srcs or [ ]) ];
  opaqueFields = builtins.filter (name:
    lib.subtractLists knownContexts (contextKeys application.drvAttrs.${name}) != [ ]
  ) (builtins.attrNames (builtins.removeAttrs application.drvAttrs [
    "stdenv" "src" "srcs" "allowedReferences" "disallowedReferences"
    "allowedRequisites" "disallowedRequisites" "outputChecks"
  ]));

  # Nix's reference checks need concrete paths. The two closure manifests are
  # intentionally realized at evaluation (IFD), only for the requested leaf.
  # Exempt legitimate runtime and infrastructure closures, not all build inputs.
  buildOnly = lib.filter (input: !(builtins.elem (inputPath input) (map inputPath runtime))) scopes.build;
  forbiddenRoots = lib.unique (buildOnly ++ removed);
  closurePaths = roots:
    lib.filter (path: path != "") (lib.splitString "\n"
      (builtins.readFile "${pkgs.closureInfo { rootPaths = roots; }}/store-paths"));
  sourceInputs = lib.filter (source: source != null)
    (lib.flatten [ (original.src or null) (original.srcs or [ ]) ]);
  sourceCaptures = if forbiddenInputs == [ ] || sourceInputs == [ ] then [ ] else
    # Runtime eligibility cannot authorize executing a captured tool during build.
    lib.intersectLists (closurePaths forbiddenInputs)
      (lib.subtractLists (closurePaths (buildInputs ++ [ stdenv ])) (closurePaths sourceInputs));
  disallowed = if forbiddenRoots == [ ] then [ ] else lib.subtractLists
    (closurePaths (runtime ++ [ stdenv ])) (closurePaths forbiddenRoots);
  application = replaced.overrideAttrs (old: {
    disallowedReferences = (old.disallowedReferences or [ ]) ++ disallowed;
    # A source symlink can retain a forbidden dependency without a direct reference.
    disallowedRequisites = (old.disallowedRequisites or [ ]) ++ disallowed;
  });

  wrapped = pkgs.runCommand "${provider.name}-zpkg-commands" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    disallowedReferences = disallowed;
    disallowedRequisites = disallowed;
    preferLocalBuild = true;
    allowSubstitutes = false;
  } ''
    fail() { echo "ZPKG runtime command backend: $*" >&2; exit 1; }
    # No library/plugin environment is inferred from a runtime declaration.
    for directory in lib lib64 include; do
      test ! -e "${application}/$directory" || fail "application exports $directory; library/plugin output wrapping is unsupported"
    done
    test -d ${application}/bin || fail "application has no bin directory; only CLI runtime wrapping is supported"
    ${lib.concatMapStrings (dependency: ''
      test -d ${dependency}/bin || fail "${dependency.name}: dependency has no bin directory; runtime library/plugin linkage is unsupported"
      for directory in lib lib64 include; do
        if test -e "${dependency}/$directory" || test -L "${dependency}/$directory"; then
          fail "${dependency.name}: dependency exports $directory; runtime library/plugin linkage is unsupported"
        fi
      done
      found=
      for command in ${dependency}/bin/*; do
        if test -f "$command" && test -x "$command"; then found=1; fi
      done
      test -n "$found" || fail "${dependency.name}: dependency has no executable commands"
    '') runtime}
    mkdir -p "$out/bin"
    shopt -s nullglob dotglob
    for file in ${application}/*; do
      test "$(basename "$file")" = bin || ln -s "$file" "$out/$(basename "$file")"
    done
    found=
    for command in ${application}/bin/*; do
      test -f "$command" && test -x "$command" || fail "non-executable or directory in application bin: $command"
      makeWrapper "$command" "$out/bin/$(basename "$command")" \
        --prefix PATH : ${lib.escapeShellArg (lib.makeBinPath runtime)}
      found=1
    done
    test -n "$found" || fail "application has no executable commands"
  '';
  result = if runtime == [ ] then application else wrapped // {
    # Keep provider-facing passthru and metadata, not its old derivation identity.
    passthru = provider.passthru or { };
    meta = provider.meta or { };
  };
  checked =
    if !(provider ? overrideAttrs && provider ? drvAttrs && provider ? stdenv) then
      fail "opaque provider; explicit dependencies require an overrideAttrs-capable native stdenv recipe"
    else if !(native stdenv) || !(native pkgs.stdenv) || provider.system != pkgs.stdenv.buildPlatform.system then
      fail "cross-compilation or a foreign build platform is unsupported"
    else if !single provider then fail "multioutput providers are unsupported with explicit dependencies"
    else if discardsReferences original then
      fail "original drvAttrs enable unsafeDiscardReferences; dependency reference checks cannot be enforced"
    else if specialOutputs original then
      fail "fixed-output and content-addressed recipe replacement is unsupported"
    else if original.builder != probe.drvAttrs.builder || original.args != probe.drvAttrs.args then
      fail "custom/opaque builder or builder arguments are unsupported; use the native stdenv builder"
    else if !builtins.isAttrs (metadata.dependencies or { })
      || !lib.all (name: builtins.elem name [ "general" "build" "runtime" ]) (builtins.attrNames scopes)
      || !lib.all builtins.isList (builtins.attrValues scopes) then
      fail "dependencies must be general, build, and runtime lists"
    else if !lib.all lib.isDerivation declared then fail "dependencies must resolve to derivations"
    else if !lib.all single declared then fail "multioutput dependencies are unsupported by the command backend"
    else if !lib.all (dependency: dependency.system == provider.system
      && (!(dependency ? stdenv) || native dependency.stdenv)) declared then
      fail "cross-compilation or foreign dependency platforms are unsupported"
    else if !lib.all (input: lib.isDerivation input && single input) oldInputs then
      fail "opaque setup-hook paths or multioutput original dependencies require a recipe-specific backend"
    else if discardsReferences application.drvAttrs then
      fail "final drvAttrs enable unsafeDiscardReferences; dependency reference checks cannot be enforced"
    else if specialOutputs application.drvAttrs then
      fail "final drvAttrs enable fixed-output or content-addressed recipe replacement; a recipe-specific backend is required"
    else if application.drvAttrs.builder != probe.drvAttrs.builder || application.drvAttrs.args != probe.drvAttrs.args
      || application.drvAttrs.stdenv != original.stdenv || !single application
      || (application.drvAttrs.src or null) != (original.src or null)
      || (application.drvAttrs.srcs or [ ]) != (original.srcs or [ ]) then
      fail "replacement changes builder, stdenv, outputs, or source; a recipe-specific backend is required"
    else if capturedFields != [ ] then
      fail "recipe still captures removed or runtime-only dependencies in final drvAttrs: ${lib.concatStringsSep ", " capturedFields}; arbitrary recipe rewriting is unsupported"
    else if opaqueFields != [ ] then
      fail "opaque auxiliary input contexts in final drvAttrs: ${lib.concatStringsSep ", " opaqueFields}; cannot prove removal through generated scripts or auxiliary derivations; a recipe-specific backend is required"
    else if sourceCaptures != [ ] then
      fail "source retains removed or runtime-only dependency references: ${lib.concatStringsSep ", " sourceCaptures}; arbitrary source/recipe rewriting is unsupported"
    else result;
in
if !(builtins.isAttrs provider && (provider.type or null) == "derivation") then throw "ZPKG provider must produce a derivation"
else if !builtins.isBool dependenciesDeclared || dependenciesDeclared != (metadata ? dependencies) then
  fail "dependenciesDeclared must match the presence of metadata.dependencies"
else builtins.seq (forceMetadata metadata) (
  if !dependenciesDeclared then
    provider // { meta = (provider.meta or { }) // metadata; }
  else checked // { meta = (checked.meta or { }) // metadata // { dependencies = scopes; }; }
)
