{ pkgs, hostname, lib, ... }:

let
  # Layout compartilhado. O logo e escolhido por host sem duplicar os modulos.
  commonSettings = builtins.fromJSON (builtins.readFile ./fastfetch/config.jsonc);
  isBocchi = hostname == "bocchi";
  isFrieren = hostname == "frieren";
in
{
  programs.fastfetch = {
    enable = true;

    settings = commonSettings // {
      logo =
        if isBocchi then
          {
            source = "~/.config/fastfetch/pngs/bocchi.png";
            type = "chafa";
            height = 10;
            padding.top = 1;
          }
        else if isFrieren then
          {
            source = "~/.config/fastfetch/pngs/frieren.png";
            type = "chafa";
            height = 13;
            padding.top = 1;
          }
        else
          {
            source = "nixos";
            type = "builtin";
            padding.top = 1;
          };
    };
  };

  # Ambos os hosts usam Chafa para mostrar a imagem no Fastfetch.
  home.packages = lib.optionals (isBocchi || isFrieren) [ pkgs.chafa ];

  # Imagens declarativas separadas por host.
  xdg.configFile =
    (lib.optionalAttrs isBocchi {
      "fastfetch/pngs/bocchi.png".source = ./fastfetch/bocchi.png;
    })
    // (lib.optionalAttrs isFrieren {
      "fastfetch/pngs/frieren.png".source = ./fastfetch/frieren.png;
    });
}
