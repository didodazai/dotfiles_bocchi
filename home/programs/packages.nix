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
    discord
    telegram-desktop

    # Aplicativos do dia a dia.
    spotify
    todoist-electron
    # Frieren: Brave 1.98.60 usando o .deb oficial e SHA-256 publicado pelo upstream.
    # Bocchi preserva o pacote atualmente fixado em nixpkgs-apps.
    (if hostname == "frieren" then
      appsPkgs.brave.overrideAttrs (_: {
        version = "1.98.60";
        src = pkgs.fetchurl {
          url = "https://github.com/brave/brave-browser/releases/download/v1.98.60/brave-browser_1.98.60_amd64.deb";
          hash = "sha256-gSoAHXYxtatJ5V3sYUigvC1Fnp/AMQbChile4D/QYvw=";
        };
      })
    else
      appsPkgs.brave)
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
