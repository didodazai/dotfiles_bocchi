{ pkgs, ... }:

let
  pname = "helium";
  version = "0.19.2.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-oEVQo8fHC9rTrNOkQw7ajSr8C/cXOpxYpAP+q5UXCH8=";
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
