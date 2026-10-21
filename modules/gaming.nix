{ pkgs, username, ... }:

let
  # Arquivo oficial para "outras distribuicoes Linux".
  # Hash fixo: se a Mojang substituir o tarball, revisar antes de atualizar.
  minecraftTarball = pkgs.fetchurl {
    url = "https://launcher.mojang.com/download/Minecraft.tar.gz";
    hash = "sha256-aVJpKBVHu7z0f+dGMwJ6Dk3cE6YQYMaGpyF+hdMU5F4=";
  };

  minecraftFiles = pkgs.runCommand "minecraft-launcher-official-files" { } ''
    mkdir -p "$out"
    tar -xzf ${minecraftTarball} -C "$out"
    test -x "$out/minecraft-launcher/minecraft-launcher"
  '';

  # O launcher e a JVM que ele baixa esperam uma distribuicao Linux FHS.
  # Libs do launcher e acesso ao Secret Service para salvar o login Microsoft.
  # Criar um steam-run isolado para o Minecraft, sem alterar a Steam do host.
  minecraftFhs = (pkgs.steam.override {
    extraLibraries = p: [ p.nss p.nspr p.libsecret ];
  }).run-free;

  minecraftLauncher = pkgs.writeShellApplication {
    name = "minecraft-launcher";
    runtimeInputs = [ minecraftFhs ];
    text = ''
      exec steam-run ${minecraftFiles}/minecraft-launcher/minecraft-launcher "$@"
    '';
  };
in
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
    # Binario oficial do osu!lazer: permite multiplayer e envio de pontuacoes.
    osu-lazer-bin
    minecraftLauncher
    (makeDesktopItem {
      name = "minecraft-launcher";
      desktopName = "Minecraft Launcher";
      exec = "${minecraftLauncher}/bin/minecraft-launcher";
      # Icone original extraido pelo proprio launcher da Mojang em ~/.minecraft.
      # O caminho e especifico do usuario e deste host (modulo frieren).
      icon = "/home/${username}/.minecraft/launcher/icons/minecraft256.png";
      startupWMClass = "minecraft-launcher";
      categories = [ "Game" ];
    })
  ];
}
