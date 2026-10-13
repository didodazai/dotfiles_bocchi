{ pkgs, inputs, ... }:

let
  # Vopono 1.0.1 do nixpkgs-apps fixado, sem atualizar o nixpkgs base.
  appsPkgs = import inputs.nixpkgs-apps {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  # Apenas ferramentas locais. Ainda nao ativar daemon, tunel, firewall
  # nem alterar a rota ou o DNS do sistema.
  environment.systemPackages = [
    appsPkgs.vopono
    pkgs.wireguard-tools
  ];
}
