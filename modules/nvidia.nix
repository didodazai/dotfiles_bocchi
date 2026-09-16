{ ... }:

# O perfil dell-g3-3579 (nixos-hardware) já define:
#   - driver proprietário legacy_580, open = false
#   - PRIME offload + comando `nvidia-offload`
#   - Bus IDs Intel PCI:0:2:0 / NVIDIA PCI:1:0:0
# Aqui entram só os complementos.

{
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;

    # Salva a VRAM na suspensão; evita tela corrompida ao voltar.
    powerManagement.enable = true;

    # NÃO ativar: RTD3 só funciona em Turing+; a 1050 Ti é Pascal.
    powerManagement.finegrained = false;

    nvidiaSettings = true;
  };
}
