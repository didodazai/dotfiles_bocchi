{ pkgs, ... }:

let
  # Faz o build falhar se o KDL não for válido para a versão do Niri do NixOS.
  validatedConfig = pkgs.runCommand "bocchi-niri-config.kdl" {
    nativeBuildInputs = [ pkgs.niri ];
  } ''
    cp ${./niri.kdl} config.kdl
    ${pkgs.niri}/bin/niri validate -c config.kdl
    cp config.kdl $out
  '';
in
{
  xdg.configFile."niri/config.kdl".source = validatedConfig;

  # Niri usa o satellite para clientes X11 legados.
  home.packages = [
    pkgs.xwayland-satellite
  ];
}
