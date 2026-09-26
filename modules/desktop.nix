{ pkgs, ... }:

let
  sddmAstronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "japanese_aesthetic";

    themeConfig = {
      Background = "Backgrounds/bocchi-login.jpg";

      Font = "Geist";
      FontSize = "12";
      RoundCorners = "16";

      FormPosition = "center";
      VirtualKeyboardPosition = "center";
      HaveFormBackground = "false";
      PartialBlur = "false";
      FullBlur = "true";
      BlurMax = "32";
      Blur = "0.35";
      DimBackground = "0.08";

      HeaderText = "";
      HourFormat = "HH:mm";
      DateFormat = "dddd d MMMM";

      LoginFieldBackgroundColor = "#282c34";
      PasswordFieldBackgroundColor = "#282c34";
      LoginFieldTextColor = "#abb2bf";
      PasswordFieldTextColor = "#abb2bf";
      PlaceholderTextColor = "#5c6370";

      UserIconColor = "#abb2bf";
      PasswordIconColor = "#abb2bf";
      LoginButtonTextColor = "#1e2127";
      LoginButtonBackgroundColor = "#e06c75";

      SystemButtonsIconsColor = "#abb2bf";
      SessionButtonTextColor = "#abb2bf";
      VirtualKeyboardButtonTextColor = "#abb2bf";

      DropdownTextColor = "#abb2bf";
      DropdownSelectedBackgroundColor = "#353b45";
      DropdownBackgroundColor = "#1e2127";

      HighlightTextColor = "#ffffff";
      HighlightBackgroundColor = "#353b45";
      HighlightBorderColor = "#e06c75";

      HoverUserIconColor = "#61afef";
      HoverPasswordIconColor = "#61afef";
      HoverSystemButtonsIconsColor = "#61afef";
      HoverSessionButtonTextColor = "#61afef";
      HoverVirtualKeyboardButtonTextColor = "#61afef";

      WarningColor = "#e06c75";

      HideVirtualKeyboard = "true";
      HideSystemButtons = "false";
      HideLoginButton = "false";
      ForceLastUser = "true";
      PasswordFocus = "true";
      HideCompletePassword = "true";
    };
  }).overrideAttrs (oldAttrs: {
    installPhase = oldAttrs.installPhase + ''
      chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/
      cp ${../assets/wallpapers/sddm-login.jpg} \
        $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/bocchi-login.jpg
    '';
  });
in
{
  # SDDM continua em X11; a sessão do usuário é Wayland.
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";

    extraPackages = with pkgs.kdePackages; [
      qtsvg
      qtmultimedia
      qtvirtualkeyboard
    ];
  };

  services.displayManager.defaultSession = "niri";

  environment.systemPackages = [
    sddmAstronaut
  ];

  # Compositor principal e único do projeto.
  # Não instalar Nautilus só para o portal: o projeto usa Waydir.
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      geist-font
    ];

    fontconfig.defaultFonts = {
      sansSerif = [ "Geist" ];
      monospace = [ "Geist Mono" "JetBrains Mono Nerd Font" ];
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
