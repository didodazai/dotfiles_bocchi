{ inputs, username, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.zen-browser.homeModules.beta
    ./profiles/bocchi.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05"; # NÃO mudar em upgrades

  programs.home-manager.enable = true;
}
