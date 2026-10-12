{ pkgs, hostname, lib, ... }:

let
  # Layout compartilhado. O logo e escolhido por host sem duplicar os modulos.
  commonSettings = builtins.fromJSON (builtins.readFile ./fastfetch/config.jsonc);
  isBocchi = hostname == "bocchi";
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
        else
          {
            # Frieren: logo de texto nativo, sem depender de um arquivo externo.
            # Substituir por imagem propria apenas depois de escolher a arte.
            source = "nixos";
            type = "builtin";
            padding.top = 1;
          };
    };
  };

  # Mantido em ambos os hosts para preservar a disponibilidade do utilitario.
  home.packages = [ pkgs.chafa ];

  # A imagem Bocchi continua no laptop; nao precisa ser copiada para Frieren.
  xdg.configFile = lib.optionalAttrs isBocchi {
    "fastfetch/pngs/bocchi.png".source = ./fastfetch/bocchi.png;
  };
}
