{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/nvidia-frieren.nix
    ../../modules/services.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
    ../../modules/mysql.nix
    ../../modules/gaming.nix
    ../../modules/discord-relay.nix
  ];

  # Mantém no boot as mesmas opções usadas na montagem inicial.
  # O hardware-configuration.nix gerado permanece intocado.
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];

  # O ESP FAT32 precisa negar leitura a usuários comuns, inclusive do random-seed
  # usado pelo systemd-boot. Sobrescreve a máscara permissiva gerada no hardware config.
  fileSystems."/boot".options = lib.mkForce [ "fmask=0077" "dmask=0077" ];

  # Desktop conectado à tomada: usar o governor de desempenho no boot.
  # Evita que power-profiles-daemon altere o governor depois do cpufreq.
  # O bocchi mantém seus perfis de energia de laptop.
  services.power-profiles-daemon.enable = lib.mkForce false;
  powerManagement.cpuFreqGovernor = "performance";

  # Linux 7.2 não compila com o NVIDIA open 595.71.05 da revisão fixada.
  # Usar o LTS 6.18 para a instalação inicial; reavaliar kernels mais novos depois.
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  # WebHID do Pulsar X2 CrazyLight Mini: dongle 8K e USB-C.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "pulsar-webhid-rules";
      destination = "/lib/udev/rules.d/70-pulsar-webhid.rules";
      text = ''
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3710", ATTRS{idProduct}=="5406", TAG+="uaccess"
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3710", ATTRS{idProduct}=="3414", TAG+="uaccess"
      '';
    })
  ];

  # Versão inicial deste host. Não alterar em upgrades futuros.
  system.stateVersion = "26.05";
}
