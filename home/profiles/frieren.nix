{ ... }:

{
  imports = [
    ./common.nix
    ../programs/fastfetch.nix
    # Supernotes fica fora da instalação inicial: o fornecedor bloqueia download automatizado.
  ];
}
