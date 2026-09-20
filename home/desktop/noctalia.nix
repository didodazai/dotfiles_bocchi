{ config, ... }:

{
  programs.noctalia = {
    enable = true;

    settings = {
      shell = {
        font_family = "JetBrains Mono Nerd Font";
        corner_radius_scale = 0.65;
        settings_show_advanced = true;

        animation = {
          enabled = true;
          speed = 1.0;
        };

        shadow = {
          direction = "down";
          alpha = 0.2;
        };

        panel = {
          transparency_mode = "glass";
          borders = true;
          shadow = true;
          launcher_placement = "floating";
          launcher_position = "center";
        };
      };

      bar = {
        order = [ "default" ];

        default = {
          position = "top";
          enabled = true;
          reserve_space = true;
          layer = "top";

          thickness = 32;
          background_opacity = 0.0;
          border_width = 0.0;
          shadow = false;
          radius = 0;
          margin_ends = 0;
          margin_edge = 0;
          padding = 12;
          widget_spacing = 12;
          hover_highlight = false;
          font_family = "JetBrains Mono Nerd Font";
          font_weight = 500;

          capsule = false;

          start = [ "workspaces" ];
          center = [ "media" ];
          end = [
            "privacy"
            "tray"
            "cpu"
            "ram"
            "network"
            "bluetooth"
            "battery"
            "clock"
          ];
        };
      };

      widget = {
        workspaces = {
          type = "workspaces";
          style = "focus_hint";
          show_labels = false;
          show_icons = false;
          label_source = "id";
          max_label_chars = 1;
          pill_scale = 0.85;
          active_pill_size = 2.2;
          inactive_pill_size = 1.0;
          focused_color = "primary";
          occupied_color = "secondary";
          empty_color = "surface_variant";
          urgent_color = "error";
          change_color_on_hover = false;
          focused_output_only = false;
          hide_when_empty = false;
        };

        media = {
          type = "media";
          hide_artist = true;
          hide_when_no_media = true;
          art_size = 16;
          min_length = 72;
          max_length = 200;
        };

        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "none";
          show_value = true;
          show_glyph = true;
        };

        ram = {
          type = "sysmon";
          stat = "ram_pct";
          visualization = "none";
          show_value = true;
          show_glyph = true;
        };

        tray = {
          type = "tray";
          hide_passive = true;
          match_adjacent_spacing = true;
        };

        clock = {
          type = "clock";
          format = "{:%a %b %-d  %H:%M}";
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
        show_app_name = true;
        show_actions = true;
        position = "top_right";
        layer = "top";
        scale = 1.0;
        background_opacity = 0.4;
        border = true;
        offset_x = 16;
        offset_y = 40;
        collapse_on_dismiss = true;
        max_visible = 4;
      };

      osd = {
        position = "bottom_center";
        position_vertical = "bottom_center";
        orientation = "horizontal";
        scale = 1.0;
        background_opacity = 0.21;
        border = true;
        offset_x = 0;
        offset_y = 32;
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
