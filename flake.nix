{
  description = "NixOS — bocchi + frieren";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Nixpkgs independente para aplicativos de usuario selecionados.
    # Nao atualiza o sistema base, o kernel nem os drivers NVIDIA.
    nixpkgs-apps.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Mantidos sem follows para preservar os caches binários dos projetos.
    noctalia.url = "github:noctalia-dev/noctalia/v5.2.1";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Agentes de IA e aplicativo Codex, isolados da base NixOS 26.05.
    # Mantem o nixpkgs proprio para usar os pacotes testados pela Numtide.
    llm-agents.url = "github:numtide/llm-agents.nix";
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

      nixosConfigurations.frieren = mkHost {
        hostname = "frieren";
        hostModule = ./hosts/frieren;
      };
    };
}
