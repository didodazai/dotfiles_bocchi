{ pkgs, ... }:

let
  version = "0.23.0";

  src = pkgs.fetchurl {
    url = "https://github.com/Waydir/Waydir/releases/download/v${version}/waydir-${version}%2B30-linux.AppImage";
    hash = "sha256-BOTUrPzB9ar0gRTmkxbz4ZCxgOJ2J0BPwDTo9pkC4BQ=";
  };

  # O PNG 512x512 e usado como .DirIcon da AppImage oficial.
  appimageContents = pkgs.appimageTools.extract {
    pname = "waydir";
    inherit version src;
  };

  waydir = pkgs.appimageTools.wrapType2 {
    pname = "waydir";
    inherit version src;

    extraPkgs = pkgs: [
      pkgs.libepoxy
    ];

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/waydir.png \
        $out/share/icons/hicolor/512x512/apps/waydir.png
    '';
  };

  waydirDesktop = pkgs.makeDesktopItem {
    name = "waydir";
    desktopName = "Waydir";
    genericName = "File Manager";
    comment = "Fast, keyboard-first desktop file manager";
    exec = "waydir %U";
    icon = "waydir";
    categories = [ "System" "FileTools" "FileManager" ];
    mimeTypes = [ "inode/directory" ];
    startupNotify = true;
  };
in
{
  home.packages = [
    waydir
    waydirDesktop
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" = [ "waydir.desktop" ];
  };
}
