{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    php84
    php84Packages.composer
  ];

  services.mysql = {
    enable = true;
    package = pkgs.mysql84;

    settings.mysqld = {
      bind-address = "127.0.0.1";
      mysqlx-bind-address = "127.0.0.1";
    };
  };
}
