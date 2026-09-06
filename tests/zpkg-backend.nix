{ pkgs ? import <nixpkgs> { } }:
let
  inherit (pkgs) lib;
  backend = import ../lib/zen-dsl/zenlang/zpkg-runtime.nix { inherit lib pkgs; };
  command = name: text: pkgs.writeShellScriptBin name "echo ${text}";
  old = command "old-command" "old";
  buildTool = command "build-command" "built";
  generalTool = command "general-command" "general";
  runtimeTool = command "runtime-command" "runtime";
  channels = lib.genAttrs [
    "nativeBuildInputs" "buildInputs" "propagatedNativeBuildInputs" "propagatedBuildInputs"
    "checkInputs" "nativeCheckInputs" "installCheckInputs" "nativeInstallCheckInputs"
    "depsBuildBuild" "depsBuildBuildPropagated" "depsBuildTarget" "depsBuildTargetPropagated"
    "depsHostHost" "depsHostHostPropagated" "depsTargetTarget" "depsTargetTargetPropagated"
  ] (_: [ old ]);
  clearRecipe = pkgs.runCommand "zpkg-clear" (channels // {
    doCheck = true;
    doInstallCheck = true;
  }) ''
    if command -v old-command; then echo 'old dependency survived' >&2; exit 1; fi
    mkdir -p "$out/bin"
    printf '#!${pkgs.runtimeShell}\necho cleared\n' > "$out/bin/app"
    chmod +x "$out/bin/app"
  '';
  scopedRecipe = clearRecipe.overrideAttrs (_: {
    name = "zpkg-scopes";
    buildCommand = ''
      test "$(build-command)" = built
      test "$(general-command)" = general
      if command -v runtime-command || command -v old-command; then exit 1; fi
      mkdir -p "$out/bin"
      cat > "$out/bin/app" <<'EOF'
      #!${pkgs.runtimeShell}
      if command -v build-command || command -v old-command; then exit 1; fi
      general-command
      runtime-command
      EOF
      chmod +x "$out/bin/app"
    '';
  });
  runtimeRecipe = pkgs.runCommand "zpkg-runtime-only" { } ''
    if command -v runtime-command; then exit 1; fi
    mkdir -p "$out/bin"
    printf '#!${pkgs.runtimeShell}\nruntime-command\n' > "$out/bin/app"
    chmod +x "$out/bin/app"
  '';
  inherited = pkgs.runCommand "zpkg-inherited" { nativeBuildInputs = [ old ]; meta.description = "original"; } ''
    mkdir -p "$out/bin"
    test "$(old-command)" = old
    printf '#!${pkgs.runtimeShell}\necho inherited\n' > "$out/bin/app"
    chmod +x "$out/bin/app"
  '';
  explicit = provider: dependencies: backend { inherit provider; metadata = { inherit dependencies; }; };
  recursiveRecipe = pkgs.stdenv.mkDerivation (final: {
    name = "zpkg-recursive";
    nativeBuildInputs = [ old ];
    buildCommand = ''
      test "$(${lib.head final.nativeBuildInputs}/bin/build-command)" = built
      mkdir -p "$out/bin"
      printf '#!${pkgs.runtimeShell}\necho recursive\n' > "$out/bin/app"
      chmod +x "$out/bin/app"
    '';
  });
  leakingRecipe = pkgs.runCommand "zpkg-build-leak" { } ''
    mkdir -p "$out/bin"
    printf '#!${pkgs.runtimeShell}\n${buildTool}/bin/build-command\n' > "$out/bin/app"
    chmod +x "$out/bin/app"
  '';
  transitive = pkgs.runCommand "zpkg-transitive-runtime" { } ''
    mkdir -p "$out/bin"
    ln -s ${buildTool}/bin/build-command "$out/bin/runtime-command"
  '';
  sourceSymlinkRecipe = pkgs.runCommand "zpkg-source-symlink" {
    src = pkgs.writeTextDir "data" "${buildTool}";
  } ''
    mkdir -p "$out/bin"
    printf '#!${pkgs.runtimeShell}\necho source-linked\n' > "$out/bin/app"
    chmod +x "$out/bin/app"
    ln -s "$src" "$out/source"
  '';
  sourceExecutionRecipe = pkgs.runCommand "zpkg-source-execution" {
    nativeBuildInputs = [ transitive ];
    src = pkgs.writeTextDir "data" "${buildTool}";
  } ''
    tool=$(cat "$src/data")
    test "$("$tool/bin/build-command")" = built
    echo 'source tool executed'
    mkdir -p "$out/bin"
    printf '#!${pkgs.runtimeShell}\necho source-executed\n' > "$out/bin/app"
    chmod +x "$out/bin/app"
  '';
  buildCarrier = pkgs.runCommand "zpkg-build-carrier" { } ''
    mkdir -p "$out/bin"
    ln -s ${buildTool}/bin/build-command "$out/bin/build-command"
  '';
  mixedRuntimeOutput = pkgs.runCommand "zpkg-mixed-runtime-output" { } ''
    mkdir -p "$out/bin" "$out/lib"
    printf '#!${pkgs.runtimeShell}\necho helper\n' > "$out/bin/helper"
    chmod +x "$out/bin/helper"
    printf 'plugin fixture\n' > "$out/lib/libplugin.so"
  '';
  multi = pkgs.stdenv.mkDerivation { name = "zpkg-multi"; outputs = [ "out" "dev" ]; };
in {
  inherit buildTool runtimeTool generalTool;
  inheritance = backend { provider = inherited; metadata.summary = "overlay"; };
  inheritanceIdentity = let result = backend { provider = inherited; }; in
    result.drvPath == inherited.drvPath && result.outPath == inherited.outPath
    && result.meta.description == "original";
  clear = explicit clearRecipe { };
  scopes = explicit scopedRecipe { general = [ generalTool ]; build = [ buildTool ]; runtime = [ runtimeTool ]; };
  runtime = explicit runtimeRecipe { runtime = [ runtimeTool ]; };
  general = explicit (runtimeRecipe.overrideAttrs (_: {
    name = "zpkg-general";
    buildCommand = ''
      test "$(general-command)" = general
      mkdir -p "$out/bin"
      printf '#!${pkgs.runtimeShell}\ngeneral-command\n' > "$out/bin/app"
      chmod +x "$out/bin/app"
    '';
  })) { general = [ generalTool ]; };
  build = explicit (pkgs.stdenv.mkDerivation {
    name = "zpkg-native-c";
    src = pkgs.writeTextDir "app.c" ''
      #include <stdio.h>
      int main(void) { puts("native-ok"); return 0; }
    '';
    buildPhase = ''
      test "$(build-command)" = built
      $CC app.c -o app
    '';
    installPhase = ''mkdir -p "$out/bin"; cp app "$out/bin/app"'';
  }) { build = [ buildTool ]; };
  recursive = explicit recursiveRecipe { build = [ buildTool ]; };
  transitiveRuntime = explicit leakingRecipe { build = [ buildTool ]; runtime = [ transitive ]; };
  sourceSymlinkRuntime = explicit sourceSymlinkRecipe { build = [ buildTool ]; runtime = [ transitive ]; };
  sourceExecutionBuild = explicit sourceExecutionRecipe { build = [ buildTool ]; };
  sourceExecutionBuildClosure = explicit sourceExecutionRecipe { build = [ buildCarrier ]; };
  sourceExecutionGeneralClosure = explicit sourceExecutionRecipe { general = [ buildCarrier ]; };
  removedTransitiveSourceExecution = explicit sourceExecutionRecipe { };
  removedTransitiveSourceRuntimeExecution = explicit sourceExecutionRecipe { runtime = [ transitive ]; };
  sourceSymlinkLeak = explicit sourceSymlinkRecipe { build = [ buildTool ]; };
  removedTransitiveSourceLeak = explicit (sourceSymlinkRecipe.overrideAttrs (_: {
    name = "zpkg-removed-transitive-source";
    nativeBuildInputs = [ transitive ];
  })) { };
  buildLeak = explicit leakingRecipe { build = [ buildTool ]; };
  unsafeDiscardBuildLeak = explicit (leakingRecipe.overrideAttrs (_: {
    __structuredAttrs = true;
    unsafeDiscardReferences.out = true;
  })) { build = [ buildTool ]; };
  unsafeDiscardFinalBuildLeak = explicit (pkgs.stdenv.mkDerivation (final: {
    name = "zpkg-final-discard";
    __structuredAttrs = true;
    unsafeDiscardReferences.out = final ? disallowedRequisites;
    buildCommand = leakingRecipe.drvAttrs.buildCommand;
  })) { build = [ buildTool ]; };
  unsafeDiscardOriginalOnly = explicit (pkgs.stdenv.mkDerivation (final: {
    name = "zpkg-original-discard";
    __structuredAttrs = true;
    unsafeDiscardReferences.out = !(final ? disallowedRequisites);
    buildCommand = "mkdir $out";
  })) { };
  disabledDiscard = explicit (clearRecipe.overrideAttrs (_: {
    __structuredAttrs = true;
    unsafeDiscardReferences.out = false;
  })) { };
  captured = explicit (inherited.overrideAttrs (_: { buildCommand = "${old}/bin/old-command > $out"; })) { };
  finalCapture = explicit (pkgs.stdenv.mkDerivation (final: {
    name = "zpkg-final-capture";
    nativeBuildInputs = [ old ];
    buildCommand = if final ? disallowedReferences then "${old}/bin/old-command > $out" else "mkdir $out";
  })) { };
  auxiliary = explicit (inherited.overrideAttrs (_: {
    buildCommand = "source ${pkgs.writeText "captured-script" "${old}/bin/old-command > $out"}";
  })) { };
  sourceCapture = explicit (inherited.overrideAttrs (_: {
    src = pkgs.writeTextDir "setup.sh" "${old}/bin/old-command";
  })) { };
  runtimeCapture = explicit (runtimeRecipe.overrideAttrs (_: { buildCommand = "${runtimeTool}/bin/runtime-command > $out"; })) { runtime = [ runtimeTool ]; };
  opaque = explicit (builtins.derivation {
    name = "opaque"; system = pkgs.system; builder = pkgs.runtimeShell; args = [ ];
  }) { };
  foreign = explicit ((pkgs.pkgsCross.aarch64-multiplatform.stdenv.mkDerivation) { name = "foreign"; }) { };
  multioutput = explicit multi { };
  multiDependency = explicit runtimeRecipe { runtime = [ multi ]; };
  nonDerivation = backend { provider = { }; };
  customBuilder = explicit (runtimeRecipe.overrideAttrs (_: { builder = "/bin/sh"; args = [ ]; })) { };
  fixedOutput = explicit (runtimeRecipe.overrideAttrs (_: { outputHash = lib.fakeHash; outputHashAlgo = "sha256"; })) { };
  finalFixedOutput = explicit (pkgs.stdenv.mkDerivation (final: {
    name = "zpkg-final-fixed-output";
    buildCommand = "mkdir $out";
    outputHash = if final ? disallowedRequisites then lib.fakeHash else null;
    outputHashAlgo = "sha256";
  })) { };
  finalContentAddressed = explicit (pkgs.stdenv.mkDerivation (final: {
    name = "zpkg-final-content-addressed";
    __contentAddressed = final ? disallowedRequisites;
    buildCommand = "mkdir $out";
  })) { };
  runtimeLibrary = explicit runtimeRecipe { runtime = [ (pkgs.writeTextDir "lib/plugin.so" "not a command") ]; };
  mixedRuntimeLibrary = explicit runtimeRecipe { runtime = [ mixedRuntimeOutput ]; };
  mixedGeneralLibrary = explicit runtimeRecipe { general = [ mixedRuntimeOutput ]; };
  applicationLibrary = explicit (runtimeRecipe.overrideAttrs (old: {
    buildCommand = old.buildCommand + ''mkdir -p "$out/lib"'';
  })) { runtime = [ runtimeTool ]; };
}
