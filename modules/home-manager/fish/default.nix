{
  config,
  outputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.fish;
in {
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

    home.packages =
      (with pkgs; [
        tre-command
        delta
        bfs
      ])
      ++ (with pkgs.fishPlugins; [
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

        plugins = 
          (with pkgs.fishPlugins; [
            done
            autopair
            puffer
            github-copilot-cli-fish
          ])
          ++ (with pkgs; [
            {
              name = "abbreviation-tips";
              src = fetchFromGitHub {
                owner = "gazorby";
                repo = "fish-abbreviation-tips";
                rev = "0.7.0";
                hash = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
              };
            }
            {
              name = "dracula";
              src = fetchFromGitHub {
                owner = "dracula";
                repo = "fish";
                rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
                hash = "sha256-Hyq4EfSmWmxwCYhp3O8agr7VWFAflcUe8BUKh50fNfY=";
              };
            }
            {
              name = "gitnow";
              src = fetchFromGitHub {
                owner = "joseluisq";
                repo = "gitnow";
                rev = "2.12.0";
                hash = "sha256-PuorwmaZAeG6aNWX4sUTBIE+NMdn1iWeea3rJ2RhqRQ=";
              };
            }
            {
              name = "spark";
              src = fetchFromGitHub {
                owner = "jorgebucaran";
                repo = "spark.fish";
                rev = "1.2.0";
                hash = "sha256-AIFj7lz+QnqXGMBCfLucVwoBR3dcT0sLNPrQxA5qTuU=";
              };
            }
          ]);

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
          k = "kubectl";
          cat = "bat";
          tp = "trash-put";
          te = "trash-empty";
          tl = "trash-list";
          tre = "trash-restore";
          trm = "trash-rm";
          grep = "batgrep";
          watch = "batwatch";
          cat = "bat";
          find = "bfs";
          diff = "batdiff";
        };

        shellAliases = {
          ls = "eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos -w 10";
          la = "eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos -w 100";
          ".." = "cd ..";
        };

        interactiveShellInit = ''
          set -gx fish_greeting ""
        '';

        shellInit = ''
          # Theming
          set -U fish_term24bit 1
          fish_config theme choose "Dracula Official"
          set -gx COLORTERM "truecolor"
          set -gx TERM "xterm-256color"

          batman --export-env | source
          eval (batpipe)

          set -gx GPG_TTY (tty)

          if test "$(uname)" = "Darwin"
            alias apptainer "limactl shell apptainer"
          end

          function help
            $argv --help 2>&1 | bathelp
          end

          if set -q KREW_ROOT
            set -gx PATH $PATH $KREW_ROOT/.krew/bin
          else if test -d $HOME/.krew
            set -gx PATH $PATH $HOME/.krew/bin
          end
         
          set -gx COLORTERM "truecolor"
          set -gx TERM "xterm-256color"
          set -gx EDITOR "nvim"
          set -gx PAGER "less"
          set -gx BATPIPE "color"
          set -gx BATDIFF_USE_DELTA true"

          if test -d "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t"
            set -gx SSH_AUTH_SOCK "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else if test -d "$HOME/.1password"
            set -gx SSH_AUTH_SOCK "~/.1password/agent.sock"
          end

          # Set up fzf
          set -gx fzf_preview_dir eza --all --color=always
          set -gx fzf_preview_file bat
          set -gx fzf_fd_opts --hidden
          set -gx fzf_diff_highlighter batdiff
        '';
      };
    };

    home.file."./.config/fish/themes/Dracula Official.theme" = {
      recursive = true;
      source = ./DraculaOfficial.theme;
    };
  };
}
