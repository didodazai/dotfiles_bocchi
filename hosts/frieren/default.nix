{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/nvidia-frieren.nix
    ../../modules/services.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
    ../../modules/gaming.nix
  ];

  # Mantém no boot as mesmas opções usadas na montagem inicial.
  # O hardware-configuration.nix gerado permanece intocado.
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];

  # Linux 7.2 não compila com o NVIDIA open 595.71.05 da revisão fixada.
  # Usar o LTS 6.18 para a instalação inicial; reavaliar kernels mais novos depois.
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  # Versão inicial deste host. Não alterar em upgrades futuros.
  system.stateVersion = "26.05";
}
