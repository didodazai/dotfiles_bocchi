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

  # Sunsama somente no bocchi; o frieren usa seu proprio perfil.
  home.packages = [ appsPkgs.sunsama ];
}
