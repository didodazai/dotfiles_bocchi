# Passo a passo — instalação do bocchi

## 1. Instalador gráfico (Calamares)
- Idioma pt-BR, fuso America/Sao_Paulo, teclado Portuguese (Brazil) / ABNT2.
- Desktop: **No desktop**.
- Permitir software não-livre: sim.
- Particionamento: **Apagar disco**, sem swap em disco, **sem criptografia**.
  - Se oferecer "swap", escolha "sem swap" (usamos zram).
- Usuário: `dddz` (ou o que você definir no flake.nix).
- Hostname: `bocchi` (ou o que você definir no flake.nix).

## 2. Primeiro boot (tela de texto)
Logar com seu usuário e conectar o Wi-Fi:

    nmtui

## 3. Trazer este repositório
Opção A — GitHub:

    nix-shell -p git
    git clone https://github.com/didodazai/dotfiles_bocchi ~/nixos-config

Opção B — pendrive: copie a pasta `nixos-config` para `~/nixos-config`.

## 4. Preparar
    cd ~/nixos-config
    cp /etc/nixos/hardware-configuration.nix hosts/bocchi/
    git init   # (pule se veio do GitHub)
    git add .

O flake só enxerga arquivos adicionados ao Git — por isso o `git add .`.

## 5. Primeiro rebuild
    sudo nixos-rebuild boot --flake .#bocchi \
      --option experimental-features "nix-command flakes"
    reboot

(Depois do primeiro rebuild, flakes já ficam ativos e o `--option` não é mais necessário.)

## 6. Validar
No SDDM, entre na sessão **Mango**. Se algo der errado, saia e tente **Hyprland**.
Em último caso: no menu de boot, escolha a geração anterior.

    nvidia-smi
    nvidia-offload glxinfo | grep "OpenGL renderer"
    ls -l /dev/dri/by-path
    wpctl status
    powerprofilesctl

## 7. Commit
    git add . && git commit -m "Base funcionando"
