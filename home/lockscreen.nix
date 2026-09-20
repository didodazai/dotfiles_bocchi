{ pkgs, ... }:

let
  bocchi-lock = pkgs.writeShellScriptBin "bocchi-lock" ''
    exec ${pkgs.swaylock-effects}/bin/swaylock \
      --daemonize \
      --screenshots \
      --clock \
      --indicator \
      --indicator-radius 75 \
      --indicator-thickness 5 \
      --effect-blur 7x5 \
      --effect-vignette 0.2:0.5 \
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
