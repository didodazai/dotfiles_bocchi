{ pkgs, hostname, ... }:

let
  # Bocchi testa a versão nova primeiro; Frieren mantém a versão anterior.
  isBocchi = hostname == "bocchi";
  version = if isBocchi then "0.75.5" else "0.75.0";
  releaseCommit = if isBocchi then
    "e4789bbe423912faa668dc29e013436280428fe6"
  else
    "0754837254309a566ace488b3a8de245c7a82ea5";
  sourceHash = if isBocchi then
    "sha256-XF72qTA2xn/ualMMSjIl0eCvoWmV2CmXHq8K/sUJaaA="
  else
    "sha256-5Jd/G6x1kBa4Q0tWQoPbdXdDRgK0/azWUuJpn6WfTw8=";

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
