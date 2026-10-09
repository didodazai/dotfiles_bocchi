{ inputs, username, hostname, ... }:

let
  profile = ./profiles + "/${hostname}.nix";
in
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.zen-browser.homeModules.beta
    profile
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05"; # NÃO mudar em upgrades

  programs.home-manager.enable = true;
}
