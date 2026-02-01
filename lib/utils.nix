# LOCATION: lib/utils.nix
# DESCRIPTION: Core utilities, licenses, and platform definitions.

{
  lib,
  inputs,
  self,
}:

let
  cpuDb = {
    # --- INTEL ---
    "nehalem" = "v2";
    "westmere" = "v2";
    "sandybridge" = "v2";
    "ivybridge" = "v2"; # Server (i7-3770)

    "haswell" = "v3";
    "broadwell" = "v3";
    "skylake" = "v3";
    "kabylake" = "v3";
    "coffeelake" = "v3";
    "cometlake" = "v3";

    "alderlake" = "v3";
    "raptorlake" = "v3";
    "meteorlake" = "v3";
    "arrowlake" = "v3";
    "gracemont" = "v3";

    "skylake-avx512" = "v4";
    "cascadelake" = "v4";
    "cooperlake" = "v4";
    "cannonlake" = "v4";
    "icelake-client" = "v4";
    "icelake-server" = "v4";
    "tigerlake" = "v4";
    "rocketlake" = "v4";
    "sapphirerapids" = "v4";
    "emeraldrapids" = "v4";

    # --- AMD ---
    "btver1" = "v2";
    "btver2" = "v2";
    "bdver1" = "v2";
    "bdver2" = "v2";
    "bdver3" = "v2";
    "bdver4" = "v3";
    "znver1" = "v3";
    "znver2" = "v3";
    "znver3" = "v3";
    "znver4" = "v4"; # Main PC (Ryzen 9 7900)
    "znver5" = "v4";

    # --- SPECIAL ---
    "x86-64" = "v1";
    "x86-64-v2" = "v2";
    "x86-64-v3" = "v3";
    "x86-64-v4" = "v4";

    # [ ! ] IMPURE AUTO-DETECTION
    # Uses -march=native. DANGEROUS for remote builds (e.g. PC building for Server).
    # Defaults ZenOS logic to 'v3' as a statistical guess for modern hardware.
    "native" = "v3";
  };
in
rec {
  osVersionString =
    let
      major = inputs.self.version.majorVer or "0";
      variant = inputs.self.version.variant or "N";
      type = inputs.self.version.type or "beta";
    in
    "${major}${variant}${type}${
      if type != "stable" then
        "b (${if (self ? shortRev) then self.shortRev else "${self.dirtyShortRev or "unknown"}"})"
      else
        ""
    }";

  # [ STANDARD ] ZenOS Platform Definition
  platforms.zenos = [ "x86_64-linux" ];

  # [ STANDARD ] NAPL License Definition
  licenses.napl = {
    shortName = "napl";
    fullName = "The Non-Aggression License 1.1";
    url = "https://github.com/negative-zero-inft/nap-license";
    free = true;
    redistributable = true;
    copyleft = true;
  };

  recursiveImports =
    path:
    let
      contents = builtins.readDir path;
      processEntry =
        name: type:
        let
          fullPath = path + "/${name}";
        in
        if type == "directory" then
          recursiveImports fullPath
        else if type == "regular" && lib.hasSuffix ".nix" name && name != "structure.nix" then
          [ fullPath ]
        else
          [ ];
    in
    lib.flatten (lib.mapAttrsToList processEntry contents);

  getZenLevel = cpu: cpuDb.${cpu} or "v2";

  makeHostPlatform = system: cpu: {
    inherit system;
    gcc.arch =
      if cpu == "native" then
        "native"
      else
        (
          {
            "v1" = "x86-64";
            "v2" = "x86-64-v2";
            "v3" = "x86-64-v3";
            "v4" = "x86-64-v4";
          }
          .${getZenLevel cpu}
        );
    gcc.tune = if (cpuDb ? ${cpu} && cpu != "native") then cpu else "generic";
  };

  isModuleEnabled =
    config: category: name:
    let
      categoryConfig = config.zenos.modules.${category} or [ ];
    in
    (categoryConfig == "*") || (lib.elem name categoryConfig);

  detectArchScript = ''
    #!/bin/sh
    echo "## [ ZenOS Hardware Detector ]"
    if ! command -v gcc >/dev/null 2>&1; then echo "Error: GCC required."; exit 1; fi
    DETECTED_ARCH=$(gcc -march=native -Q --help=target | grep --text -m1 -- "-march=" | cut -d= -f2 | xargs)
    echo "Detected: $DETECTED_ARCH"
  '';
}
