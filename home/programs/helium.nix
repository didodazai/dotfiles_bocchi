{ pkgs, hostname, ... }:

let
  pname = "helium";
  # Apenas frieren recebe o release mais novo; bocchi continua em 0.20.1.1.
  version = if hostname == "frieren" then "0.20.2.1" else "0.20.1.1";
  sourceHash = if hostname == "frieren" then
    "sha256-rEkoQk0xyGP/86t1076HPfyS7eAOaIljTcvFiBoSA5c="
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
