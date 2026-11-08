# Enrichment is deliberately separate from the data-only schema exporter.
let
  flake = builtins.getFlake "path:${toString ../.}";
  system = builtins.currentSystem;
  lib = flake.inputs.nixpkgs.lib;
  registry = flake.lib.dslRegistryFor system;
  packages = flake.legacyPackages.${system};
  safe =
    fallback: value:
    let
      result = builtins.tryEval (builtins.deepSeq value value);
    in
    if result.success then result.value else fallback;
  record =
    entry:
    let
      package = lib.getAttrFromPath entry.target packages;
      meta = package.meta or { };
      details = {
        pname = package.pname or package.name or null;
        version = package.version or null;
        outputs = package.outputs or [ "out" ];
        defaultOutput = package.outputName or "out";
        outputPaths = map (name: toString package.${name}) (package.outputs or [ "out" ]);
        homepage = meta.homepage or null;
        license = meta.license or null;
        platforms = meta.platforms or [ ];
        mainProgram = meta.mainProgram or null;
        position = meta.position or null;
        sourceRepository = meta.repositories.git or meta.downloadPage or null;
        sourceArchive = safe null (
          package.src.url or (
            let
              urls = package.src.urls or [ ];
            in
            if urls == [ ] then null else builtins.head urls
          )
        );
        upstreamMaintainers = map (m: {
          name = m.name or m.github or "Unknown";
          github = m.github or null;
          email = m.email or null;
        }) (meta.maintainers or [ ]);
        teams = safe [ ] (meta.teams or [ ]);
        broken = meta.broken or false;
        insecure = (meta.knownVulnerabilities or [ ]) != [ ];
        knownVulnerabilities = meta.knownVulnerabilities or [ ];
        unfree =
          if builtins.isAttrs (meta.license or null) && meta.license ? licenseType then
            !(lib.licenses.isFree meta.license)
          else
            lib.any (license: !(license.free or true)) (lib.toList (meta.license or { }));
      };
    in
    {
      name = entry.id;
      value = safe { status = "unavailable"; } (details // { status = "evaluated"; });
    };
in
{
  inherit system;
  sourceRoots =
    map
      (input: {
        root = toString flake.inputs.${input.name};
        repository = input.repository;
        revision = flake.inputs.${input.name}.rev or null;
      })
      [
        {
          name = "nixpkgs";
          repository = "NixOS/nixpkgs";
        }
        {
          name = "home-manager";
          repository = "nix-community/home-manager";
        }
        {
          name = "disko";
          repository = "nix-community/disko";
        }
      ];
  nixpkgsRevision = flake.inputs.nixpkgs.rev or null;
  packages = builtins.listToAttrs (map record registry.packages);
}
