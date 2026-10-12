{ pkgs, lib, hostname, ... }:

let
  # A tela do frieren usa arte propria; bocchi mantém a captura dinamica.
  # A mesma senha, PAM e o atalho Super+L permanecem inalterados.
  backgroundArgs =
    if hostname == "frieren" then
      [
        "--image" "${../assets/wallpapers/frieren-lockscreen.jpeg}"
        "--scaling" "fill"
        "--effect-blur" "2x2"
        "--effect-vignette" "0.12:0.20"
      ]
    else
      [
        "--screenshots"
        "--effect-blur" "7x5"
        "--effect-vignette" "0.2:0.5"
      ];

  bocchi-lock = pkgs.writeShellScriptBin "bocchi-lock" ''
    exec ${pkgs.swaylock-effects}/bin/swaylock \
      --daemonize \
      ${lib.escapeShellArgs backgroundArgs} \
      --clock \
      --indicator \
      --indicator-radius 75 \
      --indicator-thickness 5 \
      --timestr "%H:%M" \
      --datestr "%a %b %d" \
      --font "Inter" \
      --ring-color 88888888 \
      --inside-color 1e2127cc \
      --key-hl-color e06c75ff \
      --bs-hl-color e06c75ff \
      --text-color ffffffcc \
      --separator-color 00000000 \
      --line-color 00000000 \
      --fade-in 0.2
  '';
in
{
  home.packages = [
    pkgs.swaylock-effects
    bocchi-lock
  ];
}
