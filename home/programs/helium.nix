{ pkgs, hostname, ... }:

let
  pname = "helium";
  # AppImage oficial com SHA-256 verificado no release.
  # Frieren: versao nova com hash validado localmente; bocchi preservado.
  version = if hostname == "bocchi" then "0.21.2.1" else "0.21.3.1";
  sourceHash =
    if hostname == "bocchi" then
      "sha256-IdP+SyvmN+uT/eogjWsG1/6feO6MF9gP/57SM3AsBmo="
    else
      "sha256-qFQFIsk6R6MWBWAv08Tu2lv/g+sa0osC5NBKTIRz4p0=";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = sourceHash;
  };

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };

  helium = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/helium.desktop \
        $out/share/applications/helium.desktop

      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/helium.png \
        $out/share/icons/hicolor/256x256/apps/helium.png
    '';
  };
in
{
  home.packages = [ helium ];
}
