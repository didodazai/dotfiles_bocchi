# bocchi

Configuração declarativa do NixOS para o Dell G3 3579.

## Stack

- NixOS 26.05
- MangoWM
- Noctalia
- Foot
- Fish + Starship + Zoxide
- Zen Browser
- Home Manager
- PipeWire
- NetworkManager
- SDDM

O visual e parte do workflow são inspirados em `fufexan/dotfiles`, mas adaptados para MangoWM + Noctalia e para o hardware híbrido Intel/NVIDIA deste laptop.

## Estrutura

```text
flake.nix
hosts/bocchi/
modules/
home/
  profiles/
  desktop/
  shell/
  terminal/
  programs/
```

## Rebuild

Teste temporário:

```fish
osaragi-test
```

Aplicar permanentemente:

```fish
osaragi
```

## Restrições importantes

- Não alterar `hardware-configuration.nix` manualmente.
- Não alterar `system.stateVersion` nem `home.stateVersion`.
- Não ativar NVIDIA fine-grained power management: a GTX 1050 Ti é Pascal.
- Noctalia e Zen ficam sem `nixpkgs.follows` para preservar seus caches.
- Sem swap em disco; zram é usado.
