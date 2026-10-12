{ ... }:

{
  imports = [
    ./common.nix
  ];

  # Processamento do microfone para chamadas (Discord, etc.).
  # Home Manager instala EasyEffects e inicia seu daemon na sessao grafica.
  # Preset de supressao de ruido sera versionado depois da validacao do microfone.
  # Apenas no frieren: nao alterar o pipeline de audio do bocchi.
  services.easyeffects.enable = true;
}
