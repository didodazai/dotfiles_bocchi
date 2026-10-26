{ pkgs, hostname, ... }:

let
  # Valida o KDL compartilhado e acrescenta apenas os outputs do Frieren.
  validatedConfig = pkgs.runCommand "${hostname}-niri-config.kdl" {
    nativeBuildInputs = [ pkgs.niri ];
  } ''
    # Arquivo do Nix store vem read-only; redirecionar cria um arquivo gravavel.
    cat ${./niri.kdl} > config.kdl
    ${if hostname == "frieren" then ''
      # Frieren: evita scanout direto enquanto investigamos halos verdes
      # exclusivos do Odyssey G5. Bocchi permanece sem alteracoes.
      substituteInPlace config.kdl \
        --replace-fail \
        "    honor-xdg-activation-with-invalid-serial" \
        "    honor-xdg-activation-with-invalid-serial
    disable-direct-scanout"
    '' else ""}
    ${if hostname == "frieren" then "cat ${./frieren-outputs.kdl} >> config.kdl" else ""}
    ${pkgs.niri}/bin/niri validate -c config.kdl
    cp config.kdl $out
  '';

  # O nixpkgs fixado no flake traz xwayland-satellite 0.8.2, que fecha
  # imediatamente os menus da Steam. O upstream corrigiu isso na 0.8.3.
  # Atualizacao pontual somente no Frieren, sem atualizar o nixpkgs todo.
  xwaylandSatellite =
    if hostname == "frieren" then
      pkgs.xwayland-satellite.overrideAttrs (finalAttrs: previousAttrs: {
        version = "0.8.3";

        src = pkgs.fetchFromGitHub {
          owner = "Supreeeme";
          repo = "xwayland-satellite";
          tag = "v0.8.3";
          hash = "sha256-eFEjCCniMCKeWU0PcZNv+tDYe08SLFPjRplyPY8OFt4=";
        };

        # overrideAttrs nao recalcula o cargoDeps original do buildRustPackage.
        # Substituir tambem o vendoring para usar o Cargo.lock da versao 0.8.3.
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          name = "xwayland-satellite-0.8.3-vendor";
          src = finalAttrs.src;
          hash = "sha256-gMGFvnbxM3hD5fmkSimaFd87GEf6BXFe/MGjoS6VNVU=";
        };
      })
    else
      pkgs.xwayland-satellite;
in
{
  xdg.configFile."niri/config.kdl".source = validatedConfig;

  # Niri utiliza o Xwayland satellite para aplicativos X11 legados.
  home.packages = [
    xwaylandSatellite
  ];
}
