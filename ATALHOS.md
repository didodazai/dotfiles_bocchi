# Atalhos — Niri + Noctalia

Mapa dos atalhos declarados em `home/desktop/niri.kdl`, compartilhados entre `bocchi` e `frieren`.

**Mod** corresponde a **Super** (tecla Windows). Este documento descreve a configuracao versionada, nao substitui a verificacao de cada tecla nos hosts.

## Aplicativos

| Atalho | Aplicativo | Comando |
| --- | --- | --- |
| Super+A | Todoist | `todoist-electron` |
| Super+B | Zen Browser Beta | `zen-beta` |
| Super+D | Discord | `discord` |
| Super+E | Waydir | `waydir` |
| Super+G | Grok Bot | `grok-bot` |
| Super+N | Supernotes | `supernotes` |
| Super+P | Telegram | `telegram-desktop` |
| Super+S | Spotify | `spotify` |
| Super+T | Ghostty | `ghostty` |
| Super+X | Cursor | `cursor` |
| Super+Z | Zed | `zed` |

Os aplicativos acima estao **declarados** via Home Manager nos dois hosts, incluindo o Supernotes 3.2.4. Os programas `codex`, `agent`, `agy` e `chatgpt` tambem estao instalados, mas nao possuem atalhos `Super+...` dedicados. Podem ser abertos pelo terminal ou launcher conforme a disponibilidade de entrada desktop.

## Noctalia e sessao

| Atalho | Acao |
| --- | --- |
| Super+Espaco | Launcher do Noctalia |
| Super+Enter | Central de controle do Noctalia |
| Super+, | Configuracoes do Noctalia |
| Super+L | Bloquear tela via `bocchi-lock` (nome historico, comando disponivel em ambos os hosts) |
| Super+Shift+E | Sair do Niri (com confirmacao do compositor) |

O Noctalia inicia na sessao com `spawn-at-startup "noctalia"`. Os atalhos de controle chamam comandos `noctalia msg`.

## Janelas e areas de trabalho

| Atalho | Acao |
| --- | --- |
| Super+Q | Fechar janela |
| Super+F | Maximizar coluna |
| Super+Shift+F | Tela cheia |
| Super+V | Alternar janela flutuante |
| Super+Tab | Visao geral (Overview) |
| Super+Setas | Focar coluna ou janela |
| Super+Shift+Setas | Mover coluna ou janela |
| Super+R | Alternar largura da coluna |
| Super+C | Centralizar coluna |
| Super+1 ate Super+9 | Selecionar area de trabalho |
| Super+Shift+1 ate Super+Shift+9 | Mover coluna para area de trabalho |
| Super+PageUp / PageDown | Area de trabalho anterior / seguinte |
| Super+Roda do mouse | Mudar area de trabalho (vertical), ou focar colunas (horizontal) |

## Capturas e teclas de midia

| Atalho | Acao |
| --- | --- |
| Print | Captura interativa |
| Ctrl+Print | Captura da tela |
| Alt+Print | Captura de janela |
| Teclas de play/pausa e faixa | `playerctl` |
| Teclas de volume e mute | `noctalia msg volume-*` |
| Teclas de brilho | `noctalia msg brightness-*` |

As teclas de brilho sao uteis principalmente no laptop. No desktop, o efeito depende do controle de brilho disponivel nos monitores.

## Consideracoes por host

- **bocchi:** Niri deixa os outputs dinamicos para preservar hotplug; HDMI e ligado a NVIDIA. Nao adicionar regras globais de monitor ou alterar PRIME como parte de ajustes de atalhos.
- **frieren:** o arquivo `home/desktop/frieren-outputs.kdl` e anexado apenas neste host, com o layout dos dois monitores.
- O bloco de touchpad compartilhado e aplicavel ao laptop; no desktop sem touchpad ele nao introduz um atalho.
- `osaragi-test` e `osaragi` sao abreviacoes do **Fish**, definidas em `home/shell/fish.nix`, e nao atalhos do Niri.

## Procedimento para mudancas

Verificar os programas declarados, editar o KDL compartilhado apenas quando a mudanca deve valer nos **dois hosts** e validar o build com `osaragi-test` antes de `osaragi`. O modulo `home/desktop/niri.nix` ja executa `niri validate` durante o build. Confirmar o atalho na sessao grafica: um build bem-sucedido nao comprova que a janela abriu.
