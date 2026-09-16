{ ... }:

{
  # Rede
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Energia (PPD desliga o TLP do perfil de laptop automaticamente)
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Áudio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Chaveiro (o portal do Mango aponta Secret para o gnome-keyring)
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
}
