{ pkgs, ... }:

{
  programs.fastfetch.enable = true;

  # O preset usa o backend Chafa para renderizar a imagem da Bocchi.
  home.packages = [
    pkgs.chafa
  ];

  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  xdg.configFile."fastfetch/pngs/bocchi.png".source = ./fastfetch/bocchi.png;
}
