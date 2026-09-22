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
      format = "$username - $hostname $directory$git_branch$git_status$cmd_duration\n$character";

      username = {
        show_always = true;
        format = "[$user](bold cyan)";
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname](bold green)";
      };

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
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
