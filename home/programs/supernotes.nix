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

  # Icone original, extraido da mesma AppImage fixada pelo requireFile.
  appimageContents = pkgs.appimageTools.extract {
    pname = "supernotes";
    inherit version src;
  };

  supernotes = pkgs.appimageTools.wrapType2 {
    pname = "supernotes";
    inherit version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/supernotes.png \
        $out/share/icons/hicolor/512x512/apps/supernotes.png
    '';
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "supernotes";
    desktopName = "Supernotes";
    genericName = "Notes";
    comment = "Fast, collaborative note-taking";
    exec = "supernotes %U";
    icon = "supernotes";
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
