# AGENTS.md — NixOS multi-host

Este repositorio configura os hosts `bocchi` (laptop Dell G3 3579) e `frieren` (desktop RTX 3060). A branch de trabalho usual e `osaragi`. **Leia os arquivos atuais antes de propor ou editar qualquer coisa.** Historicos de conversas nao substituem o Git.

## Invariantes — proibido alterar

- `hosts/bocchi/hardware-configuration.nix` e `hosts/frieren/hardware-configuration.nix`.
- `system.stateVersion` e `home.stateVersion`.
- `hardware.nvidia.powerManagement.finegrained = false` no `bocchi`: GTX 1050 Ti e Pascal.
- A topologia Intel/PRIME/NVIDIA/HDMI do `bocchi` e a estabilidade de hotplug e dois monitores.
- Niri + Noctalia sao o ambiente atual. Nao reintroduzir MangoWM, Hyprland ou Vicinae.

## Escopo de alteracoes — identificar antes de editar

Classifique toda mudanca como **`bocchi`**, **`frieren`** ou **`ambos`**, com base nos imports efetivos. Identifique o outro host potencialmente afetado, mesmo quando apenas um computador estiver disponivel para testes.

- **Somente bocchi**: `hosts/bocchi/`, `modules/nvidia.nix` e `home/profiles/bocchi.nix`. Preservar Intel/PRIME/offload, HDMI na NVIDIA e hotplug.
- **Somente frieren**: `hosts/frieren/`, `modules/nvidia-frieren.nix`, `modules/gaming.nix`, `modules/discord-relay.nix`, `home/profiles/frieren.nix` e `home/desktop/frieren-outputs.kdl`. Preservar kernel, NVIDIA open e disposicao dos monitores.
- **Compartilhados por padrao**: `flake.nix`, `flake.lock`, `modules/base.nix`, `modules/services.nix`, `modules/desktop.nix`, `modules/dev.nix`, `modules/mysql.nix`, `home/profiles/common.nix` e os modulos que ele importa (`home/desktop/niri.kdl`, Noctalia, aplicativos, tema, Fish etc.). Verificar condicionais por `hostname` antes de determinar o impacto.

Se a mudanca for exclusiva de um host, preferir configuracao no perfil/host correspondente ou condicional isolada, evitando duplicar modulos comuns sem necessidade. Um commit no GitHub nao aplica a configuracao em nenhum host. Quando apenas um host puder ser testado, registrar explicitamente o outro como **validacao adiada**, nao como aprovado.

## Sincronizacao e testes seguros

1. Conferir a branch e os arquivos no GitHub; no host, verificar `hostname`, `git status --short --branch` e `git branch --show-current`.
2. Executar `git fetch origin osaragi` e `git rev-list --left-right --count HEAD...origin/osaragi`. Somente orientar `git pull --ff-only` se a arvore estiver limpa e sem commits locais divergentes; caso contrario, diagnosticar antes.
3. Para alteracoes Nix compartilhadas, quando viavel, avaliar **ambas** as configuracoes antes de aplicar: `nix eval --raw '.#nixosConfigurations.bocchi.config.system.build.toplevel.drvPath'` e o equivalente com `frieren`. Avaliacao e build nao substituem testes reais.
4. No host afetado e quando estiver disponivel, rodar `osaragi-test` (pode reiniciar servicos), confirmar sessao/aplicativos/hardware relevantes e depois `osaragi`. Se o host estiver indisponivel, adiar seu rebuild, sem bloquear mudancas documentais.
5. Registrar na conversa o commit, o escopo e quais hosts foram apenas avaliados, testados ou efetivamente atualizados. Nao criar tarefas de NixOS no Todoist sem solicitacao explicita.

**Nome futuro do repositorio:** `dotfiles_dddz`. A renomeacao ainda nao ocorreu; nao trocar URLs, remotos ou nomes de host antes de um procedimento especifico.

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
git status --short --branch
git branch --show-current
git fetch origin osaragi
git rev-list --left-right --count HEAD...origin/osaragi
```

Se a arvore estiver limpa e o historico permitir avanco rapido, executar `git pull --ff-only` e, entao, `osaragi-test`. Nao puxar alteracoes por cima de trabalho local nem presumir que ambos os hosts estao atualizados.

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
