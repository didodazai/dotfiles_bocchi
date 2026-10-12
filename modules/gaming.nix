{ pkgs, username, ... }:

{
  programs.steam = {
    enable = true;

    # Proton-GE fica disponível no seletor de compatibilidade da Steam.
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];

    protontricks.enable = true;
  };

  programs.gamemode.enable = true;

  # O grupo gamemode permite ao daemon solicitar mudancas no governor da CPU.
  # Este modulo e importado somente pelo frieren.
  users.users.${username}.extraGroups = [ "gamemode" ];

  environment.systemPackages = with pkgs; [
    heroic
  ];
}
