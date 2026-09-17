{
  description = "NixOS — bocchi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Branch "cachix" = último commit já compilado no cache.
    # Sem "follows" de propósito, senão o cache não funciona.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    # Waydir entra depois, quando chegarmos nessa etapa.
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, ... }:
    let
      # >>> CONFIRA ESTES DOIS ANTES DO PRIMEIRO REBUILD <<<
      hostname = "bocchi";
      username = "dddz";
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs hostname username; };
        modules = [
          ./hosts/bocchi

          nixos-hardware.nixosModules.dell-g3-3579

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.extraSpecialArgs = { inherit inputs username; };
            home-manager.users.${username} = import ./home;
          }
        ];
      };
    };
}
