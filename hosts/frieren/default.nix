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

  # O desktop começa no kernel mais recente disponível no nixpkgs fixado.
  # Se houver regressão com NVIDIA/Niri, o fallback será o LTS.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Versão inicial deste host. Não alterar em upgrades futuros.
  system.stateVersion = "26.05";
}
