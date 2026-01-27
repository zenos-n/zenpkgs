{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  ...
}:

stdenv.mkDerivation rec {
  pname = "template-package";
  version = "1.0.0";

  src = fetchurl {
    url = "https://example.com/source.tar.gz";
    sha256 = lib.fakeSha256;
  };

  # Runtime dependencies
  buildInputs = [ ];

  # Build-time tools (compilers, pkg-config, etc.)
  nativeBuildInputs = [
    pkg-config
  ];

  # --- Custom Phases ---
  # Uncomment and modify as needed.
  # If using standard Makefiles or CMake, you often don't need to override these manually.

  # configurePhase = ''
  #   runHook preConfigure
  #   ./configure --prefix=$out
  #   runHook postConfigure
  # '';

  # buildPhase = ''
  #   runHook preBuild
  #   make
  #   runHook postBuild
  # '';

  # installPhase = ''
  #   runHook preInstall
  #   make install
  #   runHook postInstall
  # '';

  meta = with lib; {
    description = "A short summary of what this package does";
    longDescription = ''
      This is a longer description that supports Markdown-like syntax.

      It explains:
      - What the package is for.
      - How it integrates with ZenOS.
      - Special configuration notes.
    '';
    homepage = "https://example.com";
    license = licenses.napl;
    maintainers = with maintainers; [ your-username ];

    platforms = platforms.zenos;
  };
}
