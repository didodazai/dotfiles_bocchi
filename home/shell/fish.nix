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
      format = "$username [~](dimmed white) $hostname$directory$git_branch$git_status$nix_shell$cmd_duration$status\n$character";

      username = {
        show_always = true;
        format = "[$user](bold cyan)";
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname](bold green)";
      };

      directory = {
        format = " [$path](bold blue)";
        home_symbol = "";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = " ";
        format = " [$symbol$branch](bold purple)";
      };

      git_status = {
        format = "([$all_status$ahead_behind](bold red))";
        deleted = " ✗";
        modified = " ✶";
        staged = " ✓";
        stashed = " ≡";
        ahead = " ⇡$count";
        behind = " ⇣$count";
        diverged = " ⇕⇡$ahead_count⇣$behind_count";
        untracked = " ?";
        conflicted = " =";
      };

      nix_shell = {
        symbol = " ";
        format = " [via $symbol$state](bold blue)";
      };

      cmd_duration = {
        min_time = 1000;
        format = " [took $duration](bold yellow)";
      };

      status = {
        disabled = false;
        format = " [exit $status](bold red)";
      };

      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
