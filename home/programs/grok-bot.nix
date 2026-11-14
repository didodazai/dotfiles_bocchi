{ pkgs, inputs, ... }:

let
  # Pacote Linux .deb oficial, com hash verificado.
  # A mesma versao ja foi preparada para o bocchi; frieren passa a utiliza-la.
  grokBot = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok-bot.overrideAttrs (_: {
    version = "1.0.1";
    src = pkgs.fetchurl {
      url = "https://downloads.cursor.com/grokbot/stable/7eb488cd12ea2e65065a6b227f3ab49160b618bd/linux/x64/grok-bot_1.0.1_amd64.deb";
      hash = "sha256-hghqhKmVg2uMvwncqzOr4LD954LNn6W5ikJ+3nEcwzc=";
    };
  });
in
{
  home.packages = [ grokBot ];
}
