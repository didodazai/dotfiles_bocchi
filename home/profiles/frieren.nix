{ ... }:

{
  imports = [
    ./common.nix
  ];

  # Recuperado do backup do Bluefin (EasyEffects 8.3.0) em 2026-10-12.
  # Aplicado apenas no frieren; nao altera o pipeline do bocchi.
  services.easyeffects = {
    enable = true;
    preset = "Bluefin-Microfone";

    extraPresets."Bluefin-Microfone".input = {
      blocklist = [ ];
      plugins_order = [
        "rnnoise#0"
        "deepfilternet#0"
      ];

      # O banco antigo nao continha parametros customizados do RNNoise.
      # Usamos seu modelo padrao, com bypass desligado para processar o audio.
      "rnnoise#0" = {
        bypass = false;
        "use-standard-model" = true;
      };

      "deepfilternet#0" = {
        bypass = false;
        "attenuation-limit" = 91.0;
        "post-filter-beta" = 0.019999999552965164;
      };
    };
  };
}
