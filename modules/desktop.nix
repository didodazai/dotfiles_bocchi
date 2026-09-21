{ pkgs, ... }:

{
  # SDDM continua em X11; as sessões do usuário são Wayland.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  # Durante a migração, Mango permanece como sessão padrão/fallback.
  services.displayManager.defaultSession = "mango";

  # Mantemos Mango até validar Niri no hardware real.
  programs.mangowc.enable = true;

  # Niri fica disponível como segunda sessão no SDDM.
  # Não instalar Nautilus só para o portal: o projeto usa Waydir.
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
