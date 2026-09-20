{ config, lib, pkgs, ... }:

let
  kvLibadwaita = pkgs.fetchFromGitHub {
    owner = "GabePoel";
    repo = "KvLibadwaita";
    rev = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
    hash = "sha256-32RlnRBNJajD0Ps+vZSwVfDj6HzPpZjfm/LBG7u0eDg=";
    sparseCheckout = [ "src" ];
  };

  qtFont = ''"${config.gtk.font.name},${builtins.toString config.gtk.font.size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
in
{
  # O Home Manager usa qt5ct por padrão para "qtct"; no setup do fufexan
  # isso é forçado para qt6ct para evitar inconsistências em apps Qt 6.
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    QT_STYLE_OVERRIDE = lib.mkForce null;
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qtct";

    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
        custom_palette = true;
        color_scheme_path = "${kvLibadwaita}/src/Colors/Libadwaita Dark.colors";
        icon_theme = config.gtk.iconTheme.name;
        standard_dialogs = "xdgdesktopportal";
      };

      Fonts = {
        fixed = qtFont;
        general = qtFont;
      };
    };
  };

  xdg.configFile = {
    "Kvantum/KvLibadwaita" = {
      source = "${kvLibadwaita}/src/KvLibadwaita";
      recursive = true;
    };

    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvLibadwaitaDark
    '';
  };
}
