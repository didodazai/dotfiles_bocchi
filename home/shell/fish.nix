{ config, ... }:

{
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
      fastfetch
    '';
    shellAbbrs = {
      osaragi = "sudo nixos-rebuild switch --flake ~/nixos-config#bocchi";
      osaragi-test = "sudo nixos-rebuild test --flake ~/nixos-config#bocchi";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
      git_status = {
        deleted = "✗";
        modified = "✶";
        staged = "✓";
        stashed = "≡";
      };
      nix_shell = {
        symbol = " ";
        heuristic = true;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
