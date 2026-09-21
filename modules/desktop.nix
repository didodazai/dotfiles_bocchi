{ pkgs, ... }:

{
  # SDDM continua em X11; as sessões do usuário são Wayland.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  # Niri validado no hardware real; passa a ser a sessão padrão.
  services.displayManager.defaultSession = "niri";

  # Mango permanece instalado apenas como fallback temporário.
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
