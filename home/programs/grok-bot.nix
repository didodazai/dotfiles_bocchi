{ pkgs, ... }:

let
  version = "0.72.0";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/6a17bb448f856a2390dd63ba42bf6e80e63b08fd/linux/x64/Grok_Bot_${version}.AppImage";
    hash = "sha256-pbNLtG+fBnLmSRYKtrdAtXOiUYk1ELvxVUk38Wgtr94=";
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
    # Protocolos anunciados no desktop original da AppImage oficial.
    # Nao definimos um handler padrao do sistema.
    mimeTypes = [ "x-scheme-handler/grokbot" "x-scheme-handler/sand" ];
    startupNotify = true;
  };
in
{
  home.packages = [
    grokBot
    desktopItem
  ];
}
