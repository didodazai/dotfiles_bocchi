{ pkgs, ... }:

{
  imports = [
    # Este arquivo será gerado no próprio frieren durante a instalação.
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/nvidia-frieren.nix
    ../../modules/services.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
    ../../modules/gaming.nix
  ];

  # O desktop começa no kernel mais recente disponível no nixpkgs fixado.
  # Se houver regressão com NVIDIA/Niri, o fallback será o LTS.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Versão inicial deste host. Não alterar em upgrades futuros.
  system.stateVersion = "26.05";
}
