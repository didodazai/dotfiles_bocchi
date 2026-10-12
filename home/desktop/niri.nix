{ pkgs, hostname, ... }:

let
  # Valida o KDL compartilhado e acrescenta apenas os outputs do Frieren.
  validatedConfig = pkgs.runCommand "${hostname}-niri-config.kdl" {
    nativeBuildInputs = [ pkgs.niri ];
  } ''
    # Arquivo do Nix store vem read-only; redirecionar cria um arquivo gravavel.
    cat ${./niri.kdl} > config.kdl
    ${if hostname == "frieren" then "cat ${./frieren-outputs.kdl} >> config.kdl" else ""}
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
