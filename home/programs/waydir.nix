{ pkgs, ... }:

let
  version = "0.23.0";

  waydir = pkgs.appimageTools.wrapType2 {
    pname = "waydir";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/Waydir/Waydir/releases/download/v${version}/waydir-${version}%2B30-linux.AppImage";
      hash = "sha256-BOTUrPzB9ar0gRTmkxbz4ZCxgOJ2J0BPwDTo9pkC4BQ=";
    };
  };

  waydirDesktop = pkgs.makeDesktopItem {
    name = "waydir";
    desktopName = "Waydir";
    genericName = "File Manager";
    comment = "Fast, keyboard-first desktop file manager";
    exec = "waydir %U";
    icon = "system-file-manager";
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
