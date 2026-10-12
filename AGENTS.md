# AGENTS.md — NixOS multi-host

Este repositorio configura os hosts `bocchi` (laptop Dell G3 3579) e `frieren` (desktop RTX 3060). A branch de trabalho usual e `osaragi`. **Leia os arquivos atuais antes de propor ou editar qualquer coisa.** Historicos de conversas nao substituem o Git.

## Invariantes — proibido alterar

- `hosts/bocchi/hardware-configuration.nix` e `hosts/frieren/hardware-configuration.nix`.
- `system.stateVersion` e `home.stateVersion`.
- `hardware.nvidia.powerManagement.finegrained = false` no `bocchi`: GTX 1050 Ti e Pascal.
- A topologia Intel/PRIME/NVIDIA/HDMI do `bocchi` e a estabilidade de hotplug e dois monitores.
- Niri + Noctalia sao o ambiente atual. Nao reintroduzir MangoWM, Hyprland ou Vicinae.

## Forma de trabalhar

1. Verifique `git status`, a branch ativa e o conteudo atual do arquivo. Nao sobrescreva alteracoes nao relacionadas.
2. Entenda imports, perfis e diferencas entre hosts antes de editar modulos comuns.
3. Prefira NixOS modules/Home Manager/pacotes do nixpkgs. Empacote AppImage oficial em Nix quando necessario; Flatpak somente com justificativa clara.
4. Prefira commits pequenos e reversiveis. Nao atualizar indiscriminadamente `flake.lock`, kernel, driver NVIDIA, compositor, outputs ou servicos.
5. Nao executar comandos destrutivos, `nixos-install`, particionamento, `git reset --hard`, force-push ou reboot sem autorizacao especifica.
6. Nao afirmar sucesso sem evidencia. Oriente testes no host afetado e registre o resultado obtido pelo usuario.
7. Nao modificar arquivos gerados em `~/.config` como origem das configuracoes; atualizar a fonte declarativa do repositorio.

## Validacao

Usar comandos compativeis com **Fish**. No host afetado:

```fish
cd ~/nixos-config
git pull --ff-only
osaragi-test
```

Depois de validar efeitos graficos, servicos e dispositivos:

```fish
osaragi
```

Os aliases `osaragi` e `osaragi-test` usam o hostname local. Nada de supor que passar no build valida HDMI, Bluetooth, Steam ou aplicativo grafico. No `frieren`, confirmar tambem os dois monitores; no `bocchi`, proteger a saida HDMI fisicamente ligada a NVIDIA.

## Mapa breve

- `flake.nix` e `flake.lock`: hosts e dependencias fixadas.
- `modules/`: base, desktop, dev, services, NVIDIA por host, gaming do frieren.
- `hosts/bocchi/` e `hosts/frieren/`: opcoes especificas de maquina.
- `home/profiles/common.nix`: Home Manager compartilhado; `bocchi.nix` e `frieren.nix` particularizam.
- `home/desktop/niri.kdl`: Niri compartilhado; outputs do `frieren` em `frieren-outputs.kdl`.
- `home/programs/`: configuracoes de aplicativos, incluindo ferramentas de IA.
