{ pkgs, inputs, hostname, username, ... }:

let
  # Bocchi preserva o papel de parede atual; Frieren usa a propria arte.
  backgroundName = if hostname == "frieren" then "frieren-login.jpg" else "bocchi-login.jpg";
  backgroundSource = if hostname == "frieren" then ../assets/wallpapers/sddm-frieren.jpg else ../assets/wallpapers/sddm-login.jpg;

  sddmAstronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "japanese_aesthetic";

    themeConfig = {
      Background = "Backgrounds/${backgroundName}";

      Font = "Geist";
      FontSize = "12";
      RoundCorners = "16";

      FormPosition = "center";
      VirtualKeyboardPosition = "center";
      HaveFormBackground = "false";
      PartialBlur = "false";
      FullBlur = "true";
      BlurMax = "48";
      Blur = "1.0";
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
      cp ${backgroundSource} \
        $out/share/sddm/themes/sddm-astronaut-theme/Backgrounds/${backgroundName}
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

  # Gerenciador de senhas unico em ambos os hosts, com integracao ao desktop.
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ username ];
    # Frieren recebe 1Password 8.12.38 do nixpkgs-apps fixado.
    # Bocchi continua na revisao base, sem alteracao da integracao polkit.
    package = if hostname == "frieren" then
      (import inputs.nixpkgs-apps {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      })._1password-gui
    else
      pkgs._1password-gui;
  };

  # Japones nos dois hosts; portugues continua sendo o teclado padrao.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
      waylandFrontend = true;
      settings = {
        globalOptions = {
          "Hotkey/TriggerKeys"."0" = "Control+space";
          Behavior.ActiveByDefault = false;
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "br";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = { Name = "keyboard-br"; Layout = ""; };
          "Groups/0/Items/1" = { Name = "mozc"; Layout = ""; };
          GroupOrder."0" = "Default";
        };
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
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
    # Qt usa o modulo Fcitx; GTK Wayland usa o protocolo nativo.
    QT_IM_MODULE = "fcitx";
  };
}
