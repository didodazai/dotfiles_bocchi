{
  description = "NixOS — bocchi + frieren";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Mantidos sem follows para preservar os caches binários dos projetos.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, ... }:
    let
      username = "dddz";

      mkHost =
        {
          hostname,
          hostModule,
          hardwareModules ? [ ],
          system ? "x86_64-linux",
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs hostname username;
          };

          modules =
            [ hostModule ]
            ++ hardwareModules
            ++ [
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "hm-bak";
                home-manager.extraSpecialArgs = {
                  inherit inputs hostname username;
                };
                home-manager.users.${username} = import ./home;
              }
            ];
        };
    in
    {
      nixosConfigurations.bocchi = mkHost {
        hostname = "bocchi";
        hostModule = ./hosts/bocchi;
        hardwareModules = [
          nixos-hardware.nixosModules.dell-g3-3579
        ];
      };
    };
}
