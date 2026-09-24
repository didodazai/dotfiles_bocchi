{ pkgs, ... }:

let
  version = "3.2.4";

  src = pkgs.requireFile {
    name = "Supernotes-${version}.AppImage";
    hash = "sha256-rnHlMeBOOydmtShvNbxzZnj6/Xcvs4j/p5/9YwcVxto=";
    url = "https://supernotes.app/download/";
    message = ''
      Supernotes blocks automated downloads. Download Supernotes-${version}.AppImage
      from https://supernotes.app/download/ and add it to the Nix store with:

        nix-prefetch-url file://$HOME/Downloads/Supernotes-${version}.AppImage
    '';
  };

  supernotes = pkgs.appimageTools.wrapType2 {
    pname = "supernotes";
    inherit version src;
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "supernotes";
    desktopName = "Supernotes";
    genericName = "Notes";
    comment = "Fast, collaborative note-taking";
    exec = "supernotes %U";
    icon = "accessories-text-editor";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/supernotes" ];
    startupNotify = true;
  };
in
{
  home.packages = [
    supernotes
    desktopItem
  ];

  xdg.mimeApps = {
    enable = true;
    associations.added."x-scheme-handler/supernotes" = [ "supernotes.desktop" ];
    defaultApplications."x-scheme-handler/supernotes" = [ "supernotes.desktop" ];
  };
}
