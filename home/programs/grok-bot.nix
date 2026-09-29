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

  appimageContents = pkgs.appimageTools.extractType2 {
    pname = "grok-bot";
    inherit version src;
  };

  grokBot = pkgs.appimageTools.wrapType2 {
    pname = "grok-bot";
    inherit version src;

    extraInstallCommands = ''
      icon_source="$(${pkgs.coreutils}/bin/readlink -f ${appimageContents}/.DirIcon)"

      case "$icon_source" in
        *.svg)
          install -m 444 -D "$icon_source" \
            "$out/share/icons/hicolor/scalable/apps/grok-bot.svg"
          ;;
        *)
          install -m 444 -D "$icon_source" \
            "$out/share/icons/hicolor/256x256/apps/grok-bot.png"
          ;;
      esac
    '';
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "grok-bot";
    desktopName = "Grok Bot";
    genericName = "AI Assistant";
    comment = "Grok Bot desktop application";
    exec = "grok-bot %U";
    icon = "grok-bot";
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
