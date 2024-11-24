{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "localFonts";
  version = "1.0";
  src = ./assets;

  dontUnpack = true;

  installPhase = ''
    fonts=$(ls $src/*.otf)
    for font in $fonts;do 
      font=$(basename $font)
      install -Dm644 $src/$font $out/share/fonts/opentype/$font
    done
  '';
}
