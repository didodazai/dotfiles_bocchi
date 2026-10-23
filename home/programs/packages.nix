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
    # Bocchi: Cursor mais recente via nixpkgs-apps, sem atualizar a base NixOS.
    # Frieren continua no pacote fixado ate passar por validacao propria.
    (if hostname == "bocchi" then appsPkgs.code-cursor else code-cursor)
    appsPkgs.zed-editor

    # Comunicacao.
    discord
    telegram-desktop

    # Aplicativos do dia a dia.
    spotify
    todoist-electron
    appsPkgs.brave
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
