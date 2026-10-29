{ pkgs, inputs, hostname, ... }:

let
  # Atualizacoes pontuais de aplicativos. O sistema usa nixos-26.05 fixado.
  # Evitar importar o canal novo para servicos, drivers ou Niri.
  appsPkgs = import inputs.nixpkgs-apps {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  # Atualizacao restrita ao frieren; bocchi preserva a versao validada.
  braveVersion = if hostname == "frieren" then "1.98.62" else "1.98.60";
  braveHash = if hostname == "frieren" then
    "sha256-+ytsdncm2ytWLXZhmGGLwppZDpj4KZat4qOikVO1VcE="
  else
    "sha256-gSoAHXYxtatJ5V3sYUigvC1Fnp/AMQbChile4D/QYvw=";

in
{
  home.packages = with pkgs; [
    # Editores de desenvolvimento.
    # Cursor 3.24.9 do input de apps, testado inicialmente no bocchi.
    # Frieren usa o mesmo pacote sem alterar a base do sistema.
    appsPkgs.code-cursor
    appsPkgs.zed-editor

    # Comunicacao.
    # Aplicativos mais recentes do input separado, sem alterar o NixOS base.
    appsPkgs.discord
    appsPkgs.telegram-desktop

    # Aplicativos do dia a dia.
    appsPkgs.spotify
    # Todoist 9.20.0 aguarda hash verificado da AppImage oficial mais recente.
    # Nao substituir sem teste de abertura, fuso e sincronizacao no frieren.
    todoist-electron
    # Brave estavel com hash oficial; nova versao apenas no frieren.
    (appsPkgs.brave.overrideAttrs (_: {
      version = braveVersion;
      src = pkgs.fetchurl {
        url = "https://github.com/brave/brave-browser/releases/download/v${braveVersion}/brave-browser_${braveVersion}_amd64.deb";
        hash = braveHash;
      };
    }))
    appsPkgs.proton-vpn

    # Utilitarios.
    btop
    fd
    gh
    jq
    libnotify
    playerctl
    ripgrep
  ];
}
