{ pkgs, inputs, hostname, ... }:

let
  # Atualizacoes pontuais de aplicativos. O sistema usa nixos-26.05 fixado.
  # Evitar importar o canal novo para servicos, drivers ou Niri.
  appsPkgs = import inputs.nixpkgs-apps {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

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
    # Brave 1.98.60 oficial, hash publicado no release; ambos os hosts.
    (appsPkgs.brave.overrideAttrs (_: {
      version = "1.98.60";
      src = pkgs.fetchurl {
        url = "https://github.com/brave/brave-browser/releases/download/v1.98.60/brave-browser_1.98.60_amd64.deb";
        hash = "sha256-gSoAHXYxtatJ5V3sYUigvC1Fnp/AMQbChile4D/QYvw=";
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
