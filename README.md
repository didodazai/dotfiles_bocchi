# bocchi

Configuração declarativa do NixOS para o Dell G3 3579, mantida com Flakes + Home Manager.

## Setup atual

- **NixOS 26.05**
- **Niri** como compositor Wayland
- **Noctalia** para bar, launcher, wallpaper, notificações, OSD e backdrop do Overview
- **SDDM** como display manager
- **Ghostty** como terminal
- **Fish + Starship + Zoxide**
- **Fastfetch + Chafa**
- **Waydir** como gerenciador de arquivos
- **Zen Browser**
- **swaylock-effects** para lockscreen
- **GTK:** adw-gtk3-dark, Inter e Adwaita
- **Qt:** qt6ct + Kvantum/KvLibadwaita
- **PipeWire**
- **NetworkManager**
- **BlueZ**
- **power-profiles-daemon**
- **zram** no lugar de swap em disco

## Hardware

- Dell G3 3579
- Intel Core i7-8750H
- Intel UHD 630
- NVIDIA GeForce GTX 1050 Ti Mobile
- 16 GB de RAM
- NVMe de 1 TB

O laptop usa o perfil `nixos-hardware` do Dell G3 3579, com PRIME offload para a NVIDIA. A tela interna usa a Intel e o HDMI é ligado fisicamente à NVIDIA.

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

Os principais arquivos do desktop são:

- `home/desktop/niri.kdl` — layout, binds, regras e Overview do Niri
- `home/desktop/noctalia.nix` — Noctalia, bar, wallpaper e backdrop
- `home/terminal/ghostty.nix` — Ghostty
- `home/shell/fish.nix` — Fish, Starship e Zoxide
- `home/programs/fastfetch.nix` — Fastfetch
- `modules/nvidia.nix` — complementos do setup híbrido Intel/NVIDIA

## Rebuild

Testar uma geração sem torná-la padrão no boot:

```fish
osaragi-test
```

Aplicar permanentemente:

```fish
osaragi
```

Equivalentes completos:

```fish
sudo nixos-rebuild test --flake ~/nixos-config#bocchi
sudo nixos-rebuild switch --flake ~/nixos-config#bocchi
```

## Regras do projeto

- Não editar `hosts/bocchi/hardware-configuration.nix` manualmente.
- Não alterar `system.stateVersion` nem `home.stateVersion`.
- Manter `hardware.nvidia.powerManagement.finegrained = false`: a GTX 1050 Ti é Pascal.
- Arquivos gerados pelo Home Manager em `~/.config` não são a fonte de verdade; as alterações devem ser feitas neste repositório.
