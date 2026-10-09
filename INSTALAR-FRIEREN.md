# Instalação do frieren

Este arquivo registra o plano da instalação do desktop. Não executar etapas destrutivas
sem antes confirmar o disco correto no Live USB.

## Estado planejado

- hostname: `frieren`
- usuário: `dddz`
- NixOS 26.05
- Niri + Noctalia
- SDDM
- Fish + Ghostty
- Ryzen 5 5600
- RTX 3060 dedicada
- NVIDIA open kernel module
- kernel `linuxPackages_latest` inicialmente
- Steam + Proton-GE + Protontricks + GameMode + Heroic
- zram + swap física

## Disco

O NVMe de 1 TB será usado inteiro pelo Linux.

Layout planejado:

```text
GPT
├── EFI    2 GiB    FAT32
├── SWAP  40 GiB    Linux swap
└── NixOS restante  Btrfs
```

A swap física fica pronta para uma possível hibernação futura. A hibernação não será
habilitada na instalação inicial.

Antes de particionar, confirmar o NVMe com:

```sh
lsblk -o NAME,SIZE,TYPE,FSTYPE,MODEL,MOUNTPOINTS
```

Não assumir o nome do dispositivo sem conferir a saída.

## O que já pode existir no repositório

O perfil `hosts/frieren/default.nix` pode ser preparado antes da instalação, mas
`hosts/frieren/hardware-configuration.nix` deve ser gerado no próprio desktop.

Não copiar o `hardware-configuration.nix` do bocchi.

## No Live USB

Quando estivermos no desktop:

1. confirmar `nixos-version`;
2. confirmar UEFI e o NVMe correto;
3. particionar e formatar o disco;
4. montar Btrfs/EFI e ativar a swap;
5. gerar a configuração de hardware do próprio frieren;
6. colocar `hardware-configuration.nix` em `hosts/frieren/`;
7. adicionar `nixosConfigurations.frieren` ao `flake.nix`;
8. validar a avaliação do flake;
9. instalar o NixOS pelo perfil `#frieren`;
10. reiniciar e validar NVIDIA, Niri, Noctalia, os dois monitores, rede, áudio e Bluetooth.

Depois da primeira inicialização estável, validar Steam/Proton/Heroic e jogos.
