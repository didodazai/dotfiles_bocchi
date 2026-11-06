{ pkgs, inputs, ... }:

let
  appsPkgs = import inputs.nixpkgs-apps {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./common.nix
  ];

  # Aplicativos exclusivos do bocchi; nao alterar o perfil do frieren.
  home.packages = [
    appsPkgs.sunsama

    # Herdr Desktop e seu runtime para terminais persistentes/agentes.
    # Ambos gerenciados pelo Nix, sem instalador ou atualizacao manual.
    appsPkgs.herdr-desktop
    appsPkgs.herdr-core
  ];
}
