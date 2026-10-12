{ pkgs, inputs, ... }:

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
    # Ferramentas de desenvolvimento.
    code-cursor
    appsPkgs.zed-editor

    # Comunicacao.
    discord
    telegram-desktop

    # Aplicativos do dia a dia.
    spotify
    todoist-electron
    appsPkgs.bitwarden-desktop
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
