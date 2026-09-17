# Relatório do projeto — NixOS no Dell G3 3579 ("bocchi")

Documento de passagem de contexto. Descreve o que já foi feito, o estado
atual e o que está planejado. Escrito em 17/09/2026.

---

## 1. Objetivo

Instalar e manter o NixOS num notebook Dell G3 3579, com configuração
declarativa em flake, versionada no Git. Ambiente gráfico: MangoWM
(compositor Wayland baseado em dwl/wlroots) com Noctalia como shell.
Hyprland fica instalado como sessão de fallback e ferramenta de
diagnóstico.

O notebook é usado para programação, no escritório e em casa. O desktop do
usuário ("frieren") roda Bluefin com Niri + Noctalia, e serve só como
referência de comportamento — nenhum dotfile foi copiado de lá.

### Restrições permanentes

- **Plugar qualquer monitor não pode quebrar a máquina.** Dois monitores
  são desejáveis, não obrigatórios. O que não pode acontecer é ficar sem
  poder usar o computador ao conectar um monitor diferente do configurado.
- **Sem criptografia de disco.** Nada de LUKS. Senha só no login e no sudo.
- **Sem swap em disco.** A memória extra vem do zram.
- Não mexer em `hardware-configuration.nix` nem nos `stateVersion`.
- Não ligar `hardware.nvidia.powerManagement.finegrained` (GPU Pascal, RTD3
  exige Turing+).
- Não colocar `follows` nos inputs `noctalia` e `zen-browser` (quebraria o
  cache binário pré-compilado).

---

## 2. Hardware e sistema

**Notebook:** Dell G3 3579. Intel Core i7-8750H (6c/12t), 16 GB de RAM,
NVMe de ~954 GiB. Ethernet Realtek RTL8111/8168, Wi-Fi Qualcomm Atheros
QCA9377 (`ath10k_pci`). Áudio Intel Cannon Lake PCH + HDMI Audio da NVIDIA.

**Ponto crítico do projeto — as duas GPUs:**

| GPU | PCI | card | Conectores |
|---|---|---|---|
| Intel UHD 630 | 00:02.0 | card1 | eDP-1 (painel interno), DP-1, DP-2, HDMI-A-1, HDMI-A-2 |
| NVIDIA GTX 1050 Ti Mobile | 01:00.0 | card0 | HDMI-A-3 |

A saída HDMI externa está fisicamente na NVIDIA, e o painel interno está na
Intel. É daí que vem toda a complexidade do projeto.

**Sistema:** NixOS 26.05 (Yarara), kernel 6.18.52, Nix 2.34.8. Hostname
`bocchi`, usuário `dddz` (grupos wheel, networkmanager, video), shell fish.
Locale pt_BR.UTF-8, fuso America/Sao_Paulo, teclado br-abnt2.
`stateVersion` = "26.05" no sistema e no Home Manager.

**Disco:** UEFI, sem criptografia. `nvme0n1p1` 1 GiB vfat em `/boot`,
`nvme0n1p2` com o resto em ext4 em `/`. Bootloader systemd-boot com
`configurationLimit = 15`. Sem swap em disco; zram ligado (~7,7 GiB, zstd).

**NVIDIA:** driver proprietário 580.173.02 (`legacy_580`), modo PRIME
offload, comando `nvidia-offload` disponível. `finegrained` desligado de
propósito.

---

## 3. O que foi feito

### Instalação

Feita pelo instalador gráfico (Calamares) do ISO 26.05, com "No desktop",
unfree liberado, apagar disco, sem swap, sem criptografia. A máquina tinha
Omarchy instalado com LUKS2, tudo apagado.

Antes disso, o notebook rodou CachyOS, que **não funcionava com dois
monitores**. O Omarchy funcionou, o que confirmou que o hardware dá conta e
motivou a tentativa no NixOS.

### Configuração e repositório

Repositório em `~/nixos-config`, branch `main`, remoto
`https://github.com/didodazai/dotfiles_bocchi` (público).

```
flake.nix
hosts/bocchi/default.nix          # importa os módulos
hosts/bocchi/hardware-configuration.nix
modules/base.nix                  # boot, nix, região, usuário, pacotes
modules/nvidia.nix                # complementos ao perfil do nixos-hardware
modules/services.nix              # rede, bluetooth, energia, áudio, keyring
modules/desktop.nix               # SDDM, mangowc, Hyprland, fontes
home/default.nix                  # Home Manager
home/mango.conf                   # config do compositor
docs/CONTEXTO.md                  # contexto gerado pelo Claude Code
INSTALAR.md                       # passo a passo da instalação
```

**Inputs do flake:** `nixpkgs` (nixos-26.05), `nixos-hardware`,
`home-manager` (release-26.05, com follows), `noctalia` (branch `cachix`) e
`zen-browser` (`github:0xc000022070/zen-browser-flake`). Os dois últimos
sem follows, de propósito. `base.nix` adiciona `noctalia.cachix.org` como
substituter.

O perfil `nixos-hardware.nixosModules.dell-g3-3579` faz o trabalho pesado
de hardware: driver `legacy_580` com `open = false`, PRIME offload com os
Bus IDs corretos, thermald, `acpi_osi=Linux-Dell-Video`, `dell-smm-hwmon`.

### Ambiente gráfico

- **SDDM** como display manager, greeter em X11 (caminho mais testado com
  Intel+NVIDIA), `defaultSession = "mango"`.
- **MangoWM** via `programs.mangowc.enable`, com config em
  `home/mango.conf` entregue pelo Home Manager.
- **Hyprland** sem config própria, usando o padrão autogerado (kitty em
  SUPER+Q, wofi em SUPER+R).
- **Noctalia** via módulo do Home Manager, iniciado com `exec-once` no
  Mango. Ainda configurado pela GUI, nada dele está declarativo no repo.
- Terminal alacritty (kitty também instalado), shell fish, navegadores
  Firefox e Zen (binário `zen-beta`).

### Ferramentas

- `claude-code` instalado via nixpkgs em `modules/base.nix` (versão
  2.1.223, atrás da oficial). O instalador oficial `curl | bash` **não
  funciona no NixOS**: baixa binário dinâmico genérico. A alternativa seria
  `programs.nix-ld.enable = true`.
- `gh` **não** está no config, só via `nix-shell -p gh`. Autenticação já
  feita, `gh auth setup-git` já rodado. Como o `credential.helper` global
  aponta para um caminho do `/nix/store` vindo de um `nix-shell`, um
  garbage collect pode quebrá-lo — mais um motivo para declarar o `gh` no
  `base.nix`.
- Abreviação fish `osaragi` = `sudo nixos-rebuild switch --flake
  ~/nixos-config#bocchi`, definida em `home/default.nix`.

### Correções feitas pelo caminho

- **`trackpad_disable_while_typing` não existe no Mango** (o correto é
  `disable_while_typing`). A keyword inválida fazia o parser abortar na
  linha 12, então tudo abaixo dela provavelmente nunca era aplicado: binds,
  cores, Noctalia. Corrigido pelo Claude Code. Erro de origem: veio da
  config inicial escrita pelo Claude (chat).
- Mousebinds adicionados: `SUPER + botão esquerdo` move a janela,
  `SUPER + botão direito` redimensiona.

---

## 4. Estado atual

**Funcionando:** boot, sessão Mango, Noctalia, módulos NVIDIA carregados
junto com o i915, PipeWire, NetworkManager, Bluetooth. `systemctl --failed`
e `systemctl --user --failed` retornam zero unidades.

**Monitores:** o monitor externo (Samsung Odyssey G5, 1440p) funciona na
HDMI. Existem `monitorrule` no `mango.conf` fixando HDMI-A-3 em
2560×1440@60 em (0,0) e eDP-1 em 1920×1080@60 em (320,1440) — externo em
cima, notebook embaixo e centralizado.

**Risco conhecido nessas regras:** elas casam pelo **nome da porta**, não
pelo monitor, então outro monitor ligado nessa HDMI herda a regra. O dano,
porém, é limitado: verificado no fonte do mangowc 0.12.8 (`createmon` e
`get_nearest_output_mode`), se o monitor novo não tiver um modo exatamente
2560×1440, `mode_set` fica falso e o Mango cai em
`wlr_output_preferred_mode`. Sobram `x`, `y`, `scale` e `rr` da regra
valendo — ou seja, **layout errado, não tela preta**. Tela preta seria o
caminho do `custom:1`, marcado como arriscado na doc do próprio mangowc e
que não é usado aqui.

**Solução correta:** `monitorrule` aceita `name` (regex), `make`, `model` e
`serial`, sendo os três últimos comparação exata (`strcmp`), e todos os
campos de casamento definidos precisam bater ao mesmo tempo
(`monitor_matches_rule`, em `src/mango.c`). A regra deve casar por
fabricante/modelo em vez da porta:

```
monitorrule=make:<FABRICANTE>,model:<MODELO>,width:2560,height:1440,refresh:60,x:0,y:0,scale:1
```

Falta descobrir os valores reais. Com o monitor ligado, dentro da sessão
Mango: `nix-shell -p wlr-randr --run wlr-randr`. Copiar literalmente, com
espaços e maiúsculas, porque a comparação é exata.

**Refresh rate:** o monitor ficou em 60 Hz porque o EDID dele nessa porta
HDMI reporta teto de 75 Hz vertical / 89 kHz horizontal / 250 MHz de pixel
clock, e 1440p já consome 89,45 kHz e 241,5 MHz. Nem 75 Hz cabe. Para
chegar aos 144 Hz seria preciso trocar "Input Port Ver." para HDMI 2.0 no
OSD do monitor, ou usar DisplayPort (DP-1 e DP-2 estão livres, ambos na
Intel).

### Problemas conhecidos

1. **Centenas de `PCIe Bus Error: severity=Correctable`** do `ath10k_pci` e
   do `pcieport 00:1d.6` (RxErr/BadTLP/BadDLLP). São corrigíveis, o link se
   recupera, mas poluem o journal e o console de texto. Causa provável:
   QCA9377 + ASPM. **Não verificado.**
2. `ACPI Error ... SPI1.FPNT._CRS` no boot: método ACPI do leitor de
   digital com recurso inválido no firmware.
3. `psmouse serio1: synaptics: Unable to query device: -5` no boot. Se o
   touchpad funciona na prática: **não verificado**.
4. `bluetoothd: Failed to set default system config for hci0`.

---

## 5. O que está planejado

Em ordem aproximada de prioridade:

1. **Trocar a regra do HDMI para casar por `make`/`model`** em vez do nome
   da porta. Depende de ligar o monitor e ler os valores com `wlr-randr`.
2. **Silenciar os avisos AER** do Wi-Fi no boot e no console (parâmetro de
   kernel; investigar ASPM antes).
3. **Adicionar `gh` ao `base.nix`**, para não depender de `nix-shell`.
4. **Testar os atalhos do Mango** agora que o erro de parse foi corrigido —
   pode haver coisa que parecia quebrada e passa a funcionar.
5. **Tornar o Noctalia declarativo**, migrando o que hoje é ajustado pela
   GUI para `home/default.nix`.
6. **Flatpak** (`modules/flatpak.nix`, já referenciado comentado).
7. **Jogos** (`modules/gaming.nix`, já referenciado comentado): Steam,
   `hardware.graphics.enable32Bit`, uso do `nvidia-offload`.
8. **Estética** (fontes, tema, wallpaper) — deliberadamente por último.
9. Avaliar o input `waydir`, citado em comentário no `flake.nix` e ainda
   não adicionado.

### Sobre inspirações externas

O usuário considerou copiar `github.com/fufexan/dotfiles`. A recomendação
foi **não copiar em bloco**: aquele repo usa nixos-unstable (o bocchi está
no 26.05), flake-parts, agenix para segredos, `lib/` e `pkgs/` próprios, e
é feito para Hyprland. A sugestão foi clonar numa pasta separada só para
leitura e garimpar peça por peça, adaptando para a estrutura atual.

---

## 6. Observações metodológicas

- **Hyprland como controle é um teste mais fraco do que parece.** O
  Hyprland atual usa o backend Aquamarine, não wlroots; o Mango é
  dwl/wlroots. "Funciona no Hyprland e não no Mango" não prova que o
  problema é do Mango, porque wlroots com NVIDIA proprietária como GPU
  secundária é historicamente a combinação mais problemática. Se o monitor
  externo falhar só no Mango, a variável a investigar é `WLR_DRM_DEVICES`,
  com a Intel listada primeiro.
- `~/.config/mango/config.conf` e `~/.config/fish/config.fish` são symlinks
  read-only gerados pelo Home Manager. **Não editar à mão.** As mudanças
  vão em `home/mango.conf` e `home/default.nix`, seguidas de rebuild.
- O flake só enxerga arquivo rastreado pelo Git: `git add .` antes do
  rebuild sempre que houver arquivo novo.
- `/run/current-system/sw/share/wayland-sessions` **não existe** nesta
  versão. Os `.desktop` das sessões ficam numa derivação `desktops` que o
  SDDM consome.
- `wlr-randr` não está instalado; as informações de monitor vieram de
  `/sys/class/drm`.
- O usuário está aprendendo Linux e Nix no processo. Explicações curtas do
  "porquê" são bem-vindas; despejo de arquivo inteiro quando só uma linha
  muda, não.
