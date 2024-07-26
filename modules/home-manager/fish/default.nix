{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.fish;
in
{

  imports = [
    ./autojump.nix
    ./bat.nix
    ./btop.nix
    ./dircolors.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gpg.nix
    ./jq.nix
    ./ripgrep.nix
    ./starship.nix
    ./tealdeer.nix
    ./thefuck.nix
    ./zoxide.nix
  ];
  
  options.profiles.fish = {
    enable = mkEnableOption "enable fish profile";
  };
  config = mkIf cfg.enable {

    

    nixpkgs = {
      # You can add overlays here
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages

        # Or define it inline, for example:
        # (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
        # })
      ];
      # Configure your nixpkgs instance
      config = {
        # Disable if you don't want unfree packages
        allowUnfree = true;
      };
    };

    home.packages = (with pkgs; [
      tre-command
      delta
      gitnow
      spark
      abbreviation-tips
      dracula
    ]) ++ (with pkgs.fishPlugins; [
      done
      autopair
      puffer
      github-copilot-cli-fish
    ]);

    profiles = {
      autojump.enable = true;
      bat.enable = true;
      btop.enable = true;
      dircolors.enable = true;
      direnv.enable = true;
      eza.enable = true;
      fzf.enable = true;
      gh.enable = true;
      git.enable = true;
      gpg.enable = true;
      jq.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      tealdeer.enable = true;
      thefuck.enable = true;
      zoxide.enable = true;
    };

    programs = {
      fish = {
        enable = true;

        shellAbbrs = {
          du = "dust";
          g = "git";
          vim = "nvim";
          vi = "nvim";
          vimdiff = "nvim -d";
          gd = "delta";
          bathelp = "bat --plain --language=help $argv";
          note = "nvim -c ':ObsidianToday<CR>' $argv";
          ":q" = "exit";
        };

        shellAliases = {
          find = "bfs";
          diff = "nvim -d";
          ls = "eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos -w 10";
          la = "eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos -w 100";
          cat = "bat";
          ".." = "cd ..";
        };

        shellInit = ''
          set -U fish_term24bit 1
          
          # Aliases
          fish_config theme choose "Dracula Official"
        
          set -gx GPG_TTY (tty)
        
          if test "$(uname)" = "Darwin"
            alias apptainer "limactl shell apptainer"
          end
        
          if set -q KITTY_INSTALLATION_DIR
            source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
            set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
          end
        
          function help
            $argv --help 2>&1 | bathelp
          end
        
          set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
          set -Ux MANROFFOPT "-c"
          set -Ux COLORTERM "truecolor"
          set -Ux TERM "xterm-256color"
          set -Ux EDITOR "nvim"
          
          if test -d "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t"
            set -gx SSH_AUTH_SOCK "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else if test -d "$HOME/.1password"
            set -gx SSH_AUTH_SOCK "~/.1password/agent.sock"
          end
        
          if test -d "$HOME/.asdf"
            source ~/.asdf/asdf.fish
          end
        '';

      };
    };

    home.file."./.config/fish/themes/Dracula Official.theme" = {
      recursive = true;
      source = ./DraculaOfficial.theme;
    };

  };
}
