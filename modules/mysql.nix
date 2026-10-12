{ pkgs, ... }:

{
  # Banco de desenvolvimento local, independente das ferramentas PHP.
  # Preservar os dados persistentes: nao apagar /var/lib/mysql.
  services.mysql = {
    enable = true;
    package = pkgs.mysql84;

    settings.mysqld = {
      bind-address = "127.0.0.1";
      mysqlx-bind-address = "127.0.0.1";
    };
  };
}
