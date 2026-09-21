{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      font-family = "JetBrains Mono Nerd Font";
      font-size = 10;

      theme = "BocchiOneDark";

      background-opacity = 0.72;
      background-blur = 40;

      window-padding-x = 4;
      window-padding-y = 4;
      window-padding-balance = true;

      cursor-style = "bar";
      cursor-style-blink = false;
    };

    themes.BocchiOneDark = {
      palette = [
        "0=#1e2127"
        "1=#e06c75"
        "2=#98c379"
        "3=#d19a66"
        "4=#61afef"
        "5=#c678dd"
        "6=#56b6c2"
        "7=#abb2bf"
        "8=#5c6370"
        "9=#e06c75"
        "10=#98c379"
        "11=#d19a66"
        "12=#61afef"
        "13=#c678dd"
        "14=#56b6c2"
        "15=#ffffff"
      ];

      background = "1e2127";
      foreground = "abb2bf";
      cursor-color = "abb2bf";
      cursor-text = "1e2127";
      selection-background = "5c6370";
      selection-foreground = "ffffff";
    };
  };

  home.sessionVariables.TERMINAL = "ghostty";
}
