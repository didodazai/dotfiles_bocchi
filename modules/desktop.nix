{ pkgs, ... }:

{
  # ---------- Login ----------
  # SDDM padrão, sem tema. Sessão X11 do SDDM = caminho mais testado
  # com Intel+NVIDIA. As sessões de usuário continuam Wayland.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "mango";

  # ---------- Compositor principal ----------
  programs.mangowc.enable = true;

  # ---------- Fallback / diagnóstico ----------
  # Sem config própria: o Hyprland gera um config padrão que usa
  # kitty (SUPER+Q) e wofi (SUPER+R), e detecta monitores sozinho.
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    wofi
  ];

  # ---------- Fontes ----------
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  # Apps Electron/Chromium em Wayland nativo
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
