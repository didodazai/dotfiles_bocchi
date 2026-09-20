{ pkgs, ... }:

{
  # SDDM continua em X11; a sessão do usuário é Wayland.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "mango";

  # Único compositor instalado pelo projeto.
  programs.mangowc.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
