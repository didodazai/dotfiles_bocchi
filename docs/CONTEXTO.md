# Contexto da máquina "bocchi"

Tudo aqui foi verificado por comando ou leitura de arquivo. O que não deu para
confirmar está marcado como **não verificado**.

## 1. Hardware

Notebook Dell G3 3579. CPU Intel Core i7-8750H (6 núcleos / 12 threads),
16 GB de RAM, um NVMe de ~954 GiB. Ethernet Realtek RTL8111/8168; Wi-Fi
Qualcomm Atheros QCA9377 802.11ac (driver `ath10k_pci`). Áudio Intel Cannon
Lake PCH cAVS mais o HDMI Audio da NVIDIA.

Duas GPUs:

- Intel UHD 630, PCI 00:02.0 = `card1`. Conectores: `eDP-1` (painel interno,
  único conectado agora), `DP-1`, `DP-2`, `HDMI-A-1`, `HDMI-A-2`.
- NVIDIA GTX 1050 Ti Mobile, PCI 01:00.0 = `card0`. Único conector: `HDMI-A-3`.
  **A saída HDMI externa está na NVIDIA.**

## 2. Sistema

NixOS 26.05 (Yarara), kernel 6.18.52, Nix 2.34.8. Hostname `bocchi`, usuário
`dddz` (wheel, networkmanager, video), shell fish. Locale pt_BR.UTF-8, fuso
America/Sao_Paulo, teclado br-abnt2. `system.stateVersion` e
`home.stateVersion` = "26.05".

UEFI, sem criptografia: `nvme0n1p1` 1 GiB vfat = `/boot`; `nvme0n1p2` resto em
ext4 = `/`. Bootloader systemd-boot, `configurationLimit = 15`. Sem swap em
disco (`swapDevices = [ ]`); zram ligado (~7,7 GiB, zstd).

NVIDIA proprietário 580.173.02 em PRIME **offload** (comando `nvidia-offload`
existe). `finegrained` desligado de propósito: RTD3 exige Turing+, a 1050 Ti é
Pascal.

## 3. Configuração

Repositório em `~/nixos-config`, branch `main`, remoto
`https://github.com/didodazai/dotfiles_bocchi`.

- `flake.nix` — hostname/username, perfil `nixos-hardware.dell-g3-3579` e o
  Home Manager como módulo NixOS.
- `hosts/bocchi/` — `default.nix` importa os módulos (`flatpak.nix` e
  `gaming.nix` comentados para o futuro) e o `hardware-configuration.nix`
  gerado.
- `modules/base.nix` — boot, flakes, cache do Noctalia, região, zram, usuário,
  pacotes de sistema. `nvidia.nix` — complementos ao perfil do nixos-hardware.
  `services.nix` — NetworkManager, Bluetooth, power-profiles-daemon, upower,
  PipeWire, gnome-keyring, polkit. `desktop.nix` — SDDM, mangowc, Hyprland,
  fontes, `NIXOS_OZONE_WL=1`.
- `home/` — `default.nix` (Home Manager) e `mango.conf` (compositor).
- `INSTALAR.md` — passo a passo da instalação original.

Inputs: `nixpkgs` (nixos-26.05), `nixos-hardware` (sem ref fixa),
`home-manager` (release-26.05, com `follows`), `noctalia` (branch `cachix`) e
`zen-browser`. Os dois últimos **não** usam `follows` de propósito: com
`follows` o nixpkgs muda, o cache binário pré-compilado deixa de bater e tudo
compila localmente. `base.nix` adiciona `noctalia.cachix.org` como substituter.

## 4. Ambiente gráfico

Compositor principal **mangowc** (`mango`), Wayland — é a sessão ativa.
Fallback **Hyprland**, sem config própria (padrão: kitty em SUPER+Q, wofi em
SUPER+R, detecta monitores sozinho). Login por **SDDM**, greeter em X11,
`defaultSession = "mango"`. Sessões existentes: `mango.desktop`,
`hyprland.desktop`, `hyprland-uwsm.desktop` — nesta versão elas não ficam em
`/run/current-system/sw/share/wayland-sessions`, que não existe.

Shell fish, terminal alacritty (kitty também instalado), navegadores Firefox e
Zen (binário `zen-beta`). Noctalia é a shell gráfica (`exec-once=noctalia`).

Atalhos em `home/mango.conf`: SUPER+Return/T alacritty, SUPER+B firefox;
SUPER+Space e SUPER+D launcher, SUPER+S control-center, SUPER+vírgula
configurações do Noctalia; SUPER+Q fecha, F tela cheia, V flutuante, Tab
overview; setas movem o foco, SUPER+SHIFT+setas trocam janelas; 1–9 trocam de
tag, SUPER+SHIFT+1–9 movem a janela; SUPER+SHIFT+R recarrega, SUPER+SHIFT+E
sai; Print recorta via slurp/grim para a área de transferência; volume e brilho
pelo Noctalia; SUPER+botão esquerdo move, direito redimensiona.

Monitores — **risco conhecido**. As `monitorrule` de `home/mango.conf` casam
pelo **nome da porta**, não pelo monitor: `HDMI-A-3` recebe 2560×1440@60 em
(0,0) e `eDP-1` 1920×1080@60 em (320,1440). Qualquer outro monitor ligado
naquela HDMI herda essa regra. Lendo o código do mangowc 0.12.8
(`monitor_matches_rule`, `get_nearest_output_mode`, `createmon`): se o monitor
novo não tiver um modo com exatamente 2560×1440, o mango cai no modo preferido
dele — ou seja, a resolução errada sozinha não apaga a tela — mas `x`, `y`,
`scale` e `rr` da regra continuam sendo aplicados, então o layout sai errado
(o `eDP-1` está fixo em y:1440, número pensado para um externo de 1440 de
altura). Só `custom:1` forçaria modo customizado, e ele não é usado aqui.

Saída manual: comentar a linha do `monitorrule` em `home/mango.conf`, rodar
`osaragi` (o `~/.config/mango/config.conf` é symlink read-only, não dá para
editar no lugar) e recarregar com **SUPER+SHIFT+R**.

Casar por fabricante/modelo **é suportado nesta versão**: `monitorrule` aceita
`name` (regex), `make`, `model` e `serial` (comparação exata), e todos os campos
de casamento definidos precisam bater. Os valores reais de `make`/`model` saem
do `wlr-randr` com o monitor conectado — `wlr-randr` não está instalado aqui e
o monitor externo não está ligado, então esses valores seguem **não
verificados**.

O EDID do externo por HDMI limita a 75 Hz; 144 Hz exigiria DisplayPort.

## 5. Como eu trabalho

Rebuild: `sudo nixos-rebuild switch --flake ~/nixos-config#bocchi`, ou a
abreviação fish **`osaragi`** (definida em `home/default.nix`). O flake só
enxerga arquivo rastreado pelo git: `git add .` antes do rebuild quando houver
arquivo novo.

`~/.config/mango/config.conf` e `~/.config/fish/config.fish` são symlinks
read-only gerados pelo Home Manager — **não editar à mão**; mexer em
`home/mango.conf` e `home/default.nix` e rebuildar. Noctalia ainda é
configurado pela GUI, nada dele está no repo.

Ferramentas:

- `claude-code` está em `modules/base.nix`, vindo do nixpkgs. Versão instalada:
  **2.1.223**.
- O instalador oficial (`curl | bash`) não funciona aqui: ele baixa um binário
  dinâmico genérico e no NixOS o `/lib64/ld-linux-x86-64.so.2` é apenas um stub
  (`nix-ld` não está habilitado no config), então o binário não roda. Por isso a
  versão do nixpkgs costuma ficar atrás da oficial.
- `gh` **não** está no config: uso via `nix-shell -p gh`. A autenticação já foi
  feita e o `gh auth setup-git` já rodou — o helper de credencial do git global
  aponta para o `gh` de um nix-shell, então ele pode quebrar depois de um
  garbage collect do store.

## 6. Estado atual

Funciona: boot, sessão mango, Noctalia, módulos NVIDIA carregados junto com o
i915, PipeWire, NetworkManager, Bluetooth. `systemctl --failed` e
`systemctl --user --failed` retornam zero unidades.

Pendente: Noctalia sem config declarativa; `flatpak.nix` e `gaming.nix` não
existem; o input "waydir" citado em comentário no `flake.nix` não foi
adicionado.

Problemas conhecidos:

- Centenas de `PCIe Bus Error: severity=Correctable` do `ath10k_pci` e do
  `pcieport 00:1d.6` (RxErr/BadTLP/BadDLLP). São corrigíveis — o link se
  recupera — mas poluem o journal. Causa provável QCA9377 + ASPM:
  **não verificado**.
- `ACPI Error ... SPI1.FPNT._CRS` no boot: método ACPI do leitor de digital com
  recurso inválido no firmware.
- `psmouse serio1: synaptics: Unable to query device: -5` no boot. Se o
  touchpad funciona na prática: **não verificado**.
- `bluetoothd: Failed to set default system config for hci0`.

## 7. Restrições permanentes

- Preciso plugar qualquer monitor sem quebrar a máquina: nada de config de
  vídeo que dependa de um monitor específico, nem que impeça boot/login com o
  externo desconectado.
- Sem criptografia de disco. Não sugerir LUKS.
- Sem swap em disco — a memória extra vem do zram.
- Não mexer em `hardware-configuration.nix` nem nos `stateVersion`.
- Não ligar `hardware.nvidia.powerManagement.finegrained` (GPU Pascal).
- Não colocar `follows` em `noctalia` nem em `zen-browser`.
