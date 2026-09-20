{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    fd
    gh
    jq
    libnotify
    playerctl
    ripgrep
  ];
}
