# Instalação do bocchi

## 1. Instalar o NixOS

No instalador:

- idioma: pt-BR
- fuso: America/Sao_Paulo
- teclado: Portuguese (Brazil) / ABNT2
- desktop: No desktop
- software não-livre: habilitado
- sem criptografia
- sem swap em disco
- usuário: `dddz`
- hostname: `bocchi`

O projeto usa zram no lugar de swap em disco.

## 2. Primeiro boot

Conecte a rede, se necessário:

```sh
nmtui
```

Clone o repositório:

```sh
nix-shell -p git
git clone https://github.com/didodazai/dotfiles_bocchi ~/nixos-config
cd ~/nixos-config
```

Copie a configuração de hardware gerada pela instalação:

```sh
cp /etc/nixos/hardware-configuration.nix hosts/bocchi/
git add hosts/bocchi/hardware-configuration.nix
```

## 3. Aplicar

```sh
sudo nixos-rebuild boot --flake .#bocchi \
  --option experimental-features "nix-command flakes"
reboot
```

Depois do reboot, entre na sessão **Mango** pelo SDDM.

## 4. Uso normal

Teste uma alteração:

```fish
osaragi-test
```

Aplique permanentemente:

```fish
osaragi
```

A configuração principal fica em `~/nixos-config`; arquivos gerados pelo Home Manager em `~/.config` não devem ser editados diretamente.
