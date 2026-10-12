{ pkgs, inputs, hostname, ... }:

let
  # Agentes e aplicativo ChatGPT usam os pacotes fixados pela Numtide.
  # Codex CLI usa nixpkgs-apps para nao atualizar a base NixOS.
  appsPkgs = import inputs.nixpkgs-apps {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  agentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  # https://github.com/numtide/llm-agents.nix/issues/8220
  # Usa renderizacao via software no bocchi para proteger Intel/i915.
  codexApp =
    if hostname == "bocchi" then
      agentsPkgs.chatgpt.override { commandLineArgs = "--use-gl=disabled --disable-gpu"; }
    else
      agentsPkgs.chatgpt;

  # O pacote expoe cursor-agent; a documentacao oficial usa "agent".
  cursorAgentAlias = pkgs.runCommand "cursor-agent-alias" { } ''
    mkdir -p "$out/bin"
    ln -s ${agentsPkgs.cursor-agent}/bin/cursor-agent "$out/bin/agent"
  '';
in
{
  home.packages = [
    appsPkgs.codex
    agentsPkgs.cursor-agent
    cursorAgentAlias
    agentsPkgs.antigravity-cli
    codexApp
  ];
}
