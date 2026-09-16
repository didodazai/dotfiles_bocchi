{ pkgs, hostname, username, ... }:

{
  # ---------- Boot ----------
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 15;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------- Nix ----------
  nixpkgs.config.allowUnfree = true;   # necessário para o driver NVIDIA

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  # ---------- Identidade / região ----------
  networking.hostName = hostname;
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";

  console.keyMap = "br-abnt2";
  services.xserver.xkb = {
    layout = "br";
    variant = "";   # ABNT2 padrão, com teclas mortas
  };

  # ---------- Memória ----------
  zramSwap.enable = true;

  # ---------- Usuário ----------
  programs.fish.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "didodazai";
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;
  };

  # ---------- Pacotes de sistema ----------
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    pciutils        # lspci
    usbutils        # lsusb
    mesa-demos      # glxinfo
    vulkan-tools    # vulkaninfo
    wev             # descobrir nomes de teclas
    brightnessctl
    wl-clipboard
    grim
    slurp
  ];
}
