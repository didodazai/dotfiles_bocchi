{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/nvidia.nix
    ../../modules/services.nix
    ../../modules/desktop.nix
  ];

  # Compatibilidade da instalação original. Não alterar em upgrades.
  system.stateVersion = "26.05";
}
