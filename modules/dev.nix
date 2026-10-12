{ pkgs, ... }:

{
  # Ferramentas de desenvolvimento PHP; o banco local fica em mysql.nix.
  environment.systemPackages = with pkgs; [
    php84
    php84Packages.composer
  ];
}
