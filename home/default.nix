{ inputs, username, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";   # NÃO mudar em upgrades

  programs.home-manager.enable = true;

  programs.fish.enable = true;
  programs.alacritty.enable = true;

  # Noctalia sem "settings" por enquanto: configure pela GUI primeiro,
  # depois migramos para cá o que valer a pena fixar.
  programs.noctalia.enable = true;

  xdg.configFile."mango/config.conf".source = ./mango.conf;
}
