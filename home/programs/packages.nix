{ pkgs, inputs, hostname, ... }:

let
  # Atualizacoes pontuais de aplicativos. O sistema usa nixos-26.05 fixado.
  # Evitar importar o canal novo para servicos, drivers ou Niri.
  appsPkgs = import inputs.nixpkgs-apps {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  # Brave 1.99.55: pacote oficial estavel com SHA-256 confirmado no release.
  braveVersion = "1.99.55";
  braveHash = "sha256-Nk6VSirYTVuj4OIXoinVhzxK5xB9FeYSDkIHUpU5yI0=";

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
    # Brave estavel com hash fixado para ambos os hosts.
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
