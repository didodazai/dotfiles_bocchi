{ pkgs, ... }:

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

  environment.systemPackages = with pkgs; [
    heroic
  ];
}
