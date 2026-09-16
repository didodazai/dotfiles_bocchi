{ ... }:

{
  imports = [
    ./hardware-configuration.nix   # copiado de /etc/nixos após instalar

    ../../modules/base.nix
    ../../modules/nvidia.nix
    ../../modules/services.nix
    ../../modules/desktop.nix

    # Etapas futuras (descomentar uma de cada vez):
    # ../../modules/flatpak.nix
    # ../../modules/gaming.nix
  ];

  # Compatibilidade de estado. NÃO mudar em upgrades futuros.
  system.stateVersion = "26.05";
}
