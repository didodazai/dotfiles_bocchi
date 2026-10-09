{ config, ... }:

# Desktop frieren: RTX 3060 (Ampere), GPU dedicada.
# Não reutilizar o perfil NVIDIA/PRIME do bocchi.

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # A RTX 3060 é Ampere e suporta os módulos de kernel abertos da NVIDIA.
    open = true;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
