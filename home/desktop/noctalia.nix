{ config, inputs, ... }:

{
  programs.noctalia = {
    enable = true;

    settings = {
      shell = {
        font_family = "JetBrains Mono Nerd Font";
        corner_radius_scale = 0.65;
        settings_show_advanced = true;

        panel = {
          transparency_mode = "glass";
          borders = true;
          shadow = true;
          launcher_placement = "floating";
          launcher_position = "center";
        };

        animation = {
          enabled = true;
          speed = 1.0;
        };

        shadow = {
          direction = "down";
          alpha = 0.4;
        };
      };

      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "FufexanOneDark";
      };

      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        transition = [ "fade" "zoom" ];
        transition_duration = 900;
        default.path = "${config.home.homeDirectory}/Pictures/Wallpapers/fufexan.jpg";
      };

      notification = {
        enable_daemon = true;
        background_opacity = 0.9;
        offset_x = 8;
        offset_y = 8;
      };

      osd = {
        position = "top_right";
        background_opacity = 0.9;
        offset_x = 8;
        offset_y = 8;
      };
    };

    customPalettes.FufexanOneDark = {
      dark = {
        mPrimary = "#e06c75";
        mOnPrimary = "#1e2127";
        mSecondary = "#61afef";
        mOnSecondary = "#1e2127";
        mTertiary = "#c678dd";
        mOnTertiary = "#1e2127";
        mError = "#e06c75";
        mOnError = "#1e2127";
        mSurface = "#1e2127";
        mOnSurface = "#abb2bf";
        mSurfaceVariant = "#282c34";
        mOnSurfaceVariant = "#abb2bf";
        mOutline = "#5c6370";
        mShadow = "#000000";
        mHover = "#353b45";
        mOnHover = "#ffffff";

        terminal = {
          background = "#1e2127";
          foreground = "#abb2bf";
          cursor = "#abb2bf";
          cursorText = "#1e2127";
          selectionBg = "#5c6370";
          selectionFg = "#ffffff";
          normal = {
            black = "#1e2127";
            red = "#e06c75";
            green = "#98c379";
            yellow = "#d19a66";
            blue = "#61afef";
            magenta = "#c678dd";
            cyan = "#56b6c2";
            white = "#abb2bf";
          };
          bright = {
            black = "#5c6370";
            red = "#e06c75";
            green = "#98c379";
            yellow = "#d19a66";
            blue = "#61afef";
            magenta = "#c678dd";
            cyan = "#56b6c2";
            white = "#ffffff";
          };
        };
      };
    };
  };
}
