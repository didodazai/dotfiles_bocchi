{ pkgs, ... }:

let
  version = "0.68.1";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/33103062f95061ccf9c81c5b365d37ab152c3b66/linux/x64/Grok_Bot_${version}.AppImage";
    hash = "sha256-L+fFrOzM1VehM7DGGSmX7AwTIPHp/Hvv/MprXozvuls=";
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
