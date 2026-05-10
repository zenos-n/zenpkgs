{
  lib,
  stdenvNoCC,
  fetchurl,
  nerd-font-patcher,
  python3Packages,
}:

let
  weights = [
    {
      name = "ExtraLight";
      wght = "200";
    }
    {
      name = "Light";
      wght = "300";
    }
    {
      name = "Regular";
      wght = "400";
    }
    {
      name = "Medium";
      wght = "500";
    }
    {
      name = "SemiBold";
      wght = "600";
    }
    {
      name = "Bold";
      wght = "700";
    }
    {
      name = "ExtraBold";
      wght = "800";
    }
  ];

  srcs = [
    (fetchurl {
      url = "https://github.com/google/fonts/raw/main/ofl/atkinsonhyperlegiblemono/AtkinsonHyperlegibleMono%5Bwght%5D.ttf";
      hash = "sha256-XOixaY0d7X3/IXjBo60VlHAIWljqI56LLLiPT7Sm9kY=";
    })
    (fetchurl {
      url = "https://github.com/google/fonts/raw/main/ofl/atkinsonhyperlegiblemono/AtkinsonHyperlegibleMono-Italic%5Bwght%5D.ttf";
      hash = "sha256-4Y9SOHdTDkq+Ip32o205QyYlTaSIp/Wrube16o94DNQ=";
    })
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "atkinson-hyperlegible-mono-nerd";
  version = "2024-11-20";

  inherit srcs;

  nativeBuildInputs = [
    nerd-font-patcher
    python3Packages.fonttools
    python3Packages.brotli
  ];

  unpackPhase = ''
    cp ${builtins.elemAt srcs 0} ./Roman.ttf
    cp ${builtins.elemAt srcs 1} ./Italic.ttf
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p static-files

    slice_font() {
      local input=$1
      local weight_name=$2
      local weight_value=$3
      local suffix=$4

      echo "Slicing $weight_name $suffix (wght=$weight_value)..."
      python3 -m fontTools.varLib.instancer \
        "$input" \
        "wght=$weight_value" \
        -o "static-files/AtkinsonHyperlegibleMono-''${weight_name}''${suffix}.ttf"
    }

    ${lib.concatMapStringsSep "\n" (w: ''
      slice_font Roman.ttf "${w.name}" "${w.wght}" ""
      slice_font Italic.ttf "${w.name}" "${w.wght}" "-Italic"
    '') weights}

    echo "Checking sliced files..."
    ls -l static-files/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype

    cd static-files

    for file in *.ttf; do
      # Extract weight/style info like "Bold-Italic"
      BASE_NAME=$(echo "$file" | sed 's/AtkinsonHyperlegibleMono-//; s/.ttf//')

      echo "--------------------------------------------------"
      echo "Patching: $file (Targeting weight: $BASE_NAME)"

      CUR_TEMP=$(mktemp -d)

      # The patcher keeps spitting out "AtkMono-Regular.ttf" because it's
      # blind to the sliced metadata. We force the name to "AtkMono"
      # and then manually rename the result to include the weight.
      nerd-font-patcher "$file" \
        --complete \
        --careful \
        --name "AtkMono" \
        --ext ttf \
        --out "$CUR_TEMP"

      # Find whatever the patcher created
      PATCHED_FILE=$(find "$CUR_TEMP" -name "*.ttf" | head -n 1)

      if [ -n "$PATCHED_FILE" ]; then
        # Rename it to something unique so it doesn't get nuked by the next loop iteration
        TARGET_FILE="$out/share/fonts/truetype/AtkMonoNerdFont-''${BASE_NAME}.ttf"
        echo "Moving $PATCHED_FILE to $TARGET_FILE"
        mv "$PATCHED_FILE" "$TARGET_FILE"
      else
        echo "ERROR: Patcher failed to create a file for $file"
        exit 1
      fi

      rm -rf "$CUR_TEMP"
    done

    COUNT=$(ls $out/share/fonts/truetype/*.ttf | wc -l)
    echo "--------------------------------------------------"
    echo "Build Finished. Found $COUNT fonts in output."
    ls $out/share/fonts/truetype/

    if [ "$COUNT" -lt 14 ]; then
      echo "ERROR: Expected 14 fonts, but only found $COUNT."
      exit 1
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Atkinson Hyperlegible Mono (Nerd Font Patched) - All Weights Sliced & Patched";
    homepage = "https://fonts.google.com/specimen/Atkinson+Hyperlegible+Mono";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
