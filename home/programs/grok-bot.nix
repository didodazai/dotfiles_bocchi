{ pkgs, inputs, hostname, ... }:

let
  # Versão oficial Linux x64 e hash verificado, validada primeiro no bocchi.
  isBocchi = hostname == "bocchi";
  version = if isBocchi then "0.78.1" else "0.78.1";
  releaseCommit = if isBocchi then
    "72e130b4e6be3fdc47b97e809b6b420908ce2dd8"
  else
    "72e130b4e6be3fdc47b97e809b6b420908ce2dd8";
  sourceHash = if isBocchi then
    "sha256-BQ11I8bvoEYmYROuLjsfPOlAlVSSwrlS/T5pi2DXP7g="
  else
    "sha256-BQ11I8bvoEYmYROuLjsfPOlAlVSSwrlS/T5pi2DXP7g=";

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
  # Bocchi usa o pacote .deb da Numtide; fonte e hash 1.0.1
  # confirmados no feed oficial, sem atualizar os inputs do sistema.
  # Frieren preserva a AppImage 0.78.1 previamente validada.
  home.packages =
    if hostname == "bocchi" then
      [
        (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok-bot.overrideAttrs (_: {
          version = "1.0.1";
          src = pkgs.fetchurl {
            url = "https://downloads.cursor.com/grokbot/stable/7eb488cd12ea2e65065a6b227f3ab49160b618bd/linux/x64/grok-bot_1.0.1_amd64.deb";
            hash = "sha256-hghqhKmVg2uMvwncqzOr4LD954LNn6W5ikJ+3nEcwzc=";
          };
        }))
      ]
    else
      [ grokBot desktopItem ];
}
