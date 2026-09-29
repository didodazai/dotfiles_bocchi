{ pkgs, ... }:

let
  version = "0.62.0";

  src = pkgs.requireFile {
    name = "Grok_Bot_${version}.AppImage";
    hash = "sha256-/5xfAnXt6N698rJmzogMe+uH0HUiLY/526RYoI4np80=";
    url = "https://grok.com/";
    message = ''
      Download Grok Bot ${version} for Linux as an AppImage and add it to the Nix store with:

        nix-prefetch-url file://$HOME/Downloads/Grok_Bot_${version}.AppImage
    '';
  };

  grokBot = pkgs.appimageTools.wrapType2 {
    pname = "grok-bot";
    inherit version src;
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "grok-bot";
    desktopName = "Grok Bot";
    genericName = "AI Assistant";
    comment = "Grok Bot desktop application";
    exec = "grok-bot %U";
    icon = "applications-internet";
    categories = [ "Network" "Utility" ];
    startupNotify = true;
  };
in
{
  home.packages = [
    grokBot
    desktopItem
  ];
}
