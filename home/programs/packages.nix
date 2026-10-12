{ pkgs, inputs, hostname, ... }:

let
  # Atualizacoes pontuais de aplicativos. O sistema usa nixos-26.05 fixado.
  # Evitar importar o canal novo para servicos, drivers ou Niri.
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
  home.packages = with pkgs; [
    # Ferramentas de desenvolvimento.
    code-cursor
    appsPkgs.zed-editor
    appsPkgs.codex
    agentsPkgs.cursor-agent
    cursorAgentAlias
    agentsPkgs.antigravity-cli
    codexApp

    # Comunicacao.
    discord
    telegram-desktop

    # Aplicativos do dia a dia.
    spotify
    todoist-electron
    appsPkgs.bitwarden-desktop
    appsPkgs.brave
    appsPkgs.proton-vpn

    # Utilitarios.
    btop
    fd
    gh
    jq
    libnotify
    playerctl
    ripgrep
  ];
}
