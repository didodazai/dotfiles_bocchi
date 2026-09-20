{ pkgs, hostname, username, ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 15;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  networking.hostName = hostname;

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  console.keyMap = "br-abnt2";

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  zramSwap.enable = true;

  programs.fish.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "didodazai";
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    git
    claude-code
    curl

    # Usados pelo desktop.
    brightnessctl
    grim
    slurp
    wl-clipboard
  ];
}
