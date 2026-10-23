{ pkgs, hostname, ... }:

let
  pname = "helium";
  # Helium 0.20.1.1 liberado em ambos; validar primeiro no frieren.
  version = if hostname == "bocchi" then "0.20.1.1" else "0.20.1.1";
  sourceHash = if hostname == "bocchi" then
    "sha256-1LeJsl0KmuEsdmceRE6Khe3Pgo4EGcZ40YxB+xrDAw4="
  else
    "sha256-1LeJsl0KmuEsdmceRE6Khe3Pgo4EGcZ40YxB+xrDAw4=";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = sourceHash;
  };

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };

  helium = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/helium.desktop \
        $out/share/applications/helium.desktop

      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/helium.png \
        $out/share/icons/hicolor/256x256/apps/helium.png
    '';
  };
in
{
  home.packages = [ helium ];
}
