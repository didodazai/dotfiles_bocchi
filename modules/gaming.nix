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

  # O launcher oficial da Mojang nao existe mais no nixpkgs desde 25.11.
  # Habilita apenas a infraestrutura Flatpak para testar o launcher da
  # Mojang empacotado pela comunidade (com.mojang.Minecraft, Flathub).
  # Instalar o aplicativo e verificar login/jogo antes de automatizar.
  # Modulo importado apenas pelo frieren.
  services.flatpak.enable = true;

  programs.gamemode.enable = true;

  # O grupo gamemode permite ao daemon solicitar mudancas no governor da CPU.
  # Este modulo e importado somente pelo frieren.
  users.users.${username}.extraGroups = [ "gamemode" ];

  environment.systemPackages = with pkgs; [
    heroic
  ];
}
