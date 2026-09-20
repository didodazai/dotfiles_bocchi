{ pkgs, lib, ... }:

{
  programs.foot = {
    enable = true;

    settings =
      let
        alpha = 0.9;
        blur = "yes";
      in
      {
        main = {
          font = "JetBrains Mono Nerd Font:size=10";
          horizontal-letter-offset = 0;
          vertical-letter-offset = 0;
          pad = "4x4 center";
          selection-target = "clipboard";
        };

        bell.visual = "yes";

        desktop-notifications.command =
          "${lib.getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";

        scrollback = {
          lines = 10000;
          multiplier = 3;
          indicator-position = "relative";
          indicator-format = "line";
        };

        url.launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";

        cursor = {
          style = "beam";
          beam-thickness = 1;
        };

        colors-dark = {
          inherit alpha blur;
          foreground = "abb2bf";
          background = "1e2127";
          regular0 = "1e2127";
          regular1 = "e06c75";
          regular2 = "98c379";
          regular3 = "d19a66";
          regular4 = "61afef";
          regular5 = "c678dd";
          regular6 = "56b6c2";
          regular7 = "abb2bf";
          bright0 = "5c6370";
          bright1 = "e06c75";
          bright2 = "98c379";
          bright3 = "d19a66";
          bright4 = "61afef";
          bright5 = "c678dd";
          bright6 = "56b6c2";
          bright7 = "ffffff";
        };

        colors-light = {
          inherit alpha blur;
          foreground = "383a42";
          background = "f9f9f9";
          regular0 = "000000";
          regular1 = "e45649";
          regular2 = "50a14f";
          regular3 = "986801";
          regular4 = "4078f2";
          regular5 = "a626a4";
          regular6 = "0184bc";
          regular7 = "a0a1a7";
          bright0 = "383a42";
          bright1 = "e45649";
          bright2 = "50a14f";
          bright3 = "986801";
          bright4 = "4078f2";
          bright5 = "a626a4";
          bright6 = "0184bc";
          bright7 = "ffffff";
        };
      };
  };

  home.sessionVariables.TERMINAL = "foot";
}
