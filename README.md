# NixOS — bocchi + frieren

Configuracao declarativa multi-host com **NixOS Flakes + Home Manager**, mantida na branch de trabalho `osaragi`.

## Hosts

| Host | Maquina | Diferencas principais |
| --- | --- | --- |
| `bocchi` | Dell G3 3579; i7-8750H; UHD 630 + GTX 1050 Ti; 16 GB RAM | NVIDIA Pascal com PRIME offload, tela interna Intel e HDMI na NVIDIA |
| `frieren` | Desktop Ryzen 5 5600 + RTX 3060 | NVIDIA open, kernel Linux 6.18, dois monitores com layout proprio, Steam/Proton/GameMode/Heroic, swap em disco |

Ambos usam NixOS **26.05**, Niri + Noctalia, SDDM, Ghostty, Fish, Starship, Waydir e Zen Browser Beta. O launcher e o painel sao os do Noctalia, nao do Vicinae.

O `flake.nix` declara `nixosConfigurations.bocchi` e `nixosConfigurations.frieren`. A base do sistema fica no `nixos-26.05`; aplicativos selecionados usam um input independente do nixpkgs unstable, e ferramentas de IA usam um flake fixado da Numtide. Atualizar o lockfile de um input nao exige atualizar os outros.

## Ferramentas e aplicativos

- Navegadores: Zen Browser Beta (padrao), Brave e Helium.
- Desenvolvimento: Cursor, Zed, Claude Code, PHP 8.4, Composer e MySQL local em `127.0.0.1`.
- IA no terminal: `codex`, `agent` (Cursor Agent), `agy` (Google Antigravity CLI).
- Aplicativo grafico do Codex/ChatGPT: comando `chatgpt`. No `bocchi`, ele usa flags especificas de renderizacao por software para evitar problemas com Intel/i915.
- Outros programas compartilhados: Discord, Telegram, Spotify, Todoist, Bitwarden, Proton VPN e Grok Bot.
- Supernotes 3.2.4: incluido em ambos os perfis. Como o fornecedor bloqueia downloads automatizados, seu AppImage oficial deve estar disponivel no Nix store de cada maquina com o hash declarado em `home/programs/supernotes.nix`.
- Jogos: o modulo `gaming.nix` e importado somente no `frieren`.

Versoes concretas e URLs de downloads ficam nos arquivos Nix e no `flake.lock`, nao neste README.

## Organizacao

```text
flake.nix                 # definicao dos hosts e inputs
flake.lock                # revisoes fixadas
hosts/bocchi/             # imports e hardware gerado do laptop
hosts/frieren/            # imports e hardware gerado do desktop
modules/                  # base, desktop, dev, services, NVIDIA por host, gaming
home/profiles/            # common + diferencas por host
home/desktop/             # Niri/Noctalia e layout dos monitores do frieren
home/programs/            # aplicativos Nix e empacotamentos proprios
home/shell/               # Fish e comandos osaragi
home/terminal/            # Ghostty
```

O Niri tem um arquivo KDL comum; os outputs do `frieren` sao anexados e validados durante o build. No `bocchi`, preservar a deteccao dinamica e o hotplug HDMI.

## Rebuild normal (Fish)

Em **cada host**, no clone em `~/nixos-config`:

```fish
cd ~/nixos-config
git status --short
git branch --show-current
git pull --ff-only
osaragi-test
```

Se o teste passou e os aplicativos/monitores esperados estao funcionando:

```fish
osaragi
```

Os comandos Fish detectam o hostname automaticamente e usam `#bocchi` ou `#frieren`. Nao trocar o nome do host nos comandos.

Verificacoes basicas depois de alteracoes relevantes:

```fish
systemctl --failed
systemctl --user --failed
niri msg outputs
```

Nao interpretar a ausencia de erros no build como confirmacao de que aplicativos graficos, sessao ou monitores funcionam: testar na propria maquina.

## Regras de seguranca

- **Nunca modificar** `hosts/*/hardware-configuration.nix`, `system.stateVersion` nem `home.stateVersion`.
- No `bocchi`, manter `hardware.nvidia.powerManagement.finegrained = false` (GPU Pascal) e nao arriscar configuracoes de HDMI/PRIME que possam eliminar a imagem.
- Nao substituir Niri/Noctalia por outros compositores, nem substituir o launcher do Noctalia.
- Preferir modulos NixOS, Home Manager e nixpkgs; evitar alteracoes manuais fora do Nix.
- Fazer alteracoes pequenas, especificas por host quando necessario, e validar com `osaragi-test` antes de `osaragi`.
- O estado real de cada host e validado com testes locais; commits no GitHub, por si so, nao confirmam funcionamento.

Veja tambem `AGENTS.md`, `ATALHOS.md`, `INSTALAR.md` e `INSTALAR-FRIEREN.md`.
