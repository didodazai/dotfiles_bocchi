{ pkgs, ... }:

{
  # SDDM continua em X11; a sessão do usuário é Wayland.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "niri";

  # Compositor principal e único do projeto.
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
