# frieren — registro de instalacao e operacao

> **Estado em outubro de 2026:** instalacao realizada e host `frieren` ativo no flake. Este documento nao e um roteiro de comandos a executar novamente. Nao reparticionar ou formatar o disco de um sistema ja instalado.

## Estado declarado no repositorio

- Host e usuario: `frieren`, `dddz`.
- NixOS 26.05 com Niri + Noctalia, SDDM, Ghostty e Fish.
- CPU Ryzen 5 5600; GPU dedicada RTX 3060.
- Modulos NVIDIA **abertos**; `hardware.graphics.enable32Bit = true`.
- Kernel `linuxPackages_6_18` (6.18 LTS). A escolha substituiu a proposta inicial de `linuxPackages_latest` por compatibilidade com o driver NVIDIA fixado.
- Steam, Proton-GE, Protontricks, GameMode e Heroic no `modules/gaming.nix`.
- Monitores Samsung e AOC declarados em `home/desktop/frieren-outputs.kdl`.
- Power governor `performance` e power-profiles-daemon desabilitado especificamente neste host.

## Disco e montagem (registro, nao instrucoes)

O NVMe foi preparado para uso exclusivo do NixOS, com ESP FAT32, swap fisica e particao Btrfs. O hardware gerado confirma os subvolumes `@` (raiz), `@home` e `@nix`. As opcoes `compress=zstd` e `noatime` sao declaradas no modulo do host.

O arquivo `hosts/frieren/hardware-configuration.nix` contem UUIDs reais: **nao altera-lo nem copia-lo entre maquinas**. O host aplica `fmask=0077` e `dmask=0077` em `/boot` para proteger os dados da ESP. A swap fisica existe; a hibernacao nao foi habilitada.

## Uso e testes de futuras mudancas (Fish)

```fish
cd ~/nixos-config
git status --short
git branch --show-current
git pull --ff-only
osaragi-test
```

Depois de verificar funcionamento de sessao, monitores, rede e aplicativos:

```fish
osaragi
```

Para diagnosticos nao destrutivos:

```fish
systemctl --failed
systemctl --user --failed
niri msg outputs
```

Alteracoes em NVIDIA, kernel, EFI, monitores ou compositor exigem um teste especifico e cuidado extra. Nao executar novamente as etapas de particionamento/instalacao no host pronto.

## Diferencas ainda relevantes

Supernotes 3.2.4 foi habilitado declarativamente em `home/profiles/frieren.nix`, usando o modulo ja compartilhado com `bocchi`. O AppImage oficial foi adicionado ao Nix store do desktop e o usuario confirmou funcionamento. O atalho `Mod+N` no Niri esta disponivel em ambos os hosts. Para futuras atualizacoes do Supernotes, verificar versao e hash antes de alterar o modulo.

Consulte `README.md` e `AGENTS.md` para as regras do projeto.
