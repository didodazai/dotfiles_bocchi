{ pkgs, hostname, ... }:

let
  # Frieren adota a versão oficial já declarada para o bocchi; validar em cada host.
  isBocchi = hostname == "bocchi";
  version = if isBocchi then "0.75.8" else "0.75.8";
  releaseCommit = if isBocchi then
    "039d88c52f45f8af72fbe7379bc426c171edf62b"
  else
    "039d88c52f45f8af72fbe7379bc426c171edf62b";
  sourceHash = if isBocchi then
    "sha256-OM1gaqpIUIyZazUGjKNMfllvXBGuN3Zg2vokoa3hGGM="
  else
    "sha256-OM1gaqpIUIyZazUGjKNMfllvXBGuN3Zg2vokoa3hGGM=";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/${releaseCommit}/linux/x64/Grok_Bot_${version}.AppImage";
    hash = sourceHash;
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
