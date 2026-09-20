{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.waydir.packages.${pkgs.system}.default
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications."inode/directory" = [ "waydir.desktop" ];
  };
}
