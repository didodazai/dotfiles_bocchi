{ pkgs, hostname, ... }:

let
  pname = "helium";
  # Release oficial 0.21.1.1 com hash fixado para ambos os hosts.
  version = "0.21.1.1";
  sourceHash = "sha256-pivECBuZcJsxFxZc96vnER07VEZxqxcjL0KbmwVEs/o=";

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
