{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Ferramentas de desenvolvimento.
    code-cursor
    zed-editor

    # Comunicação.
    discord
    telegram-desktop

    # Aplicativos do dia a dia.
    spotify
    todoist-electron
    bitwarden-desktop
    brave

    # Utilitários.
    btop
    fd
    gh
    jq
    libnotify
    playerctl
    ripgrep
  ];
}
