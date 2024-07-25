{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.fish;
in
{
  options.profiles.fish = {
    enable = mkEnableOption "enable fish profile";
  };
  config = mkIf cfg.enable {

    home.packages = (with pkgs; [
      starship
      thefuck
      zoxide
      direnv
      neovim
      autojump
      dircolors
      btop
      tre-command
      gnupg
      gh
      git
      fzf
      eza
      delta
      ripgrep
      jq
      tealdeer
    ]) ++ (with pkgs.fishPlugins; [
      fzf-fish
      gitnow
      z
      done
      autopair
      puffer
      github-copilot-cli-fish
      gitnow
      spark
      abbreviation-tips
      dracula
    ]);

    programs = {

      direnv = {
        enable = true;
        enableFishIntegration = true;
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      thefuck = {
        enable = true;
        enableFishIntegration = true;
      };

      autojump = {
        enable = true;
        enableFishIntegration = true;
      };

      dircolors = {
        enable = true;
        enableFishIntegration = true;
      };

      eza = {
        enable = true;
        extraOptions = [
          "-1"
          "-G"
          "-g"
          "-h"
          "-m"
          "-M"
          "-o"
          "-X"
          "-r"
          "--color=always"
          "-s"
          "created" 
          "--group-directories-first" 
          "--time-style"
          "long-iso"
          "--show-symlinks" 
          "-w"
          "10"
        ];
        icons = true;
        git = true;
      };

      fzf = {
        enable = true;
        defaultCommand = "bfs . -type f";
        fileWidgetCommand = "bfs . -type f";
        fileWidgetOptions = [ "--preview 'bat {}'" ];
        changeDirWidgetCommand = "bfs . -type d";
        changeDirWidgetOptions = [ "--preview 'tre -C {} | bat -n 200'" ];
        historyWidgetOptions = [ 
          "--sort" 
          "--exact"
          "--preview 'bat -n 20 {}'"
        ];
        colors = ''
          --color=dark
          --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
          --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
        '';
        tmux.enableShellIntegration = true;
        enableFishIntegration = true;
      };

      gh-dash.enable = true;

      gh = {
        enable = true;
        settings = {
          aliases = {
            icl = "issue close";
            icr = "issue create";
            il = "issue list";
            ire = "issue reopen";
            iv = "issue view";
            ivw = "issue view --web";
            pck = "pr checks";
            pcl = "pr close";
            pco = "pr checkout";
            pcr = "pr create";
            pd = "pr diff";
            pl = "pr list";
            pm = "pr merge";
            pre = "pr reopen";
            pv = "pr view";
            pvw = "pr view --web";
            rcl = "repo clone";
            rcr = "repo create";
            rfk = "repo fork --clone --remote";
            rv = "repo view";
            rvw = "repo view --web";
          };
          editor = "nvim";
          git_protocol = "ssh";
          prompt = "enabled";
        };
        gitCredentialHelper = {
          enable = true;
          hosts = [
            "https://github.com"
            "https://gist.github.com"
          ];
        };
      };

      git = {
        enable = true;
        userName = "Annie Ehler";
        userEmail = "annie.ehler.4@gmail.com";
        aliases = {
          a = "add";
          aa = "add --all";
          amend = "commit --amend --no-edit";
          c = "commit";
          ca = "commit -a";
          cam = "commit -a -m";
          cm = "commit -m";
          co = "checkout";
          cob = "checkout -b";
          com = "checkout master";
          d = "diff";
          dc = "diff --cached";
          lg = "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";
          pl = "pull";
          pu = "push";
          puf = "push --force";
          r = "reset HEAD";
          r1 = "reset HEAD^";
          r2 = "reset HEAD^^";
          rb = "rebase";
          rba = "rebase --abort";
          rbc = "rebase --continue";
          rbi = "rebase --interactive";
          rbs = "rebase --skip";
          rhard = "reset --hard";
          rhard1 = "reset HEAD^ --hard";
          rhard2 = "reset HEAD^^ --hard";
          rs = "restore --staged";
          s = "status";
          sd = "stash drop";
          spo = "stash pop";
          spu = "stash push";
          spua = "stash push --all";
        };
        signing = {
          key = "annie.ehler.4@gmail.com";
          signByDefault = true;
        };
        lfs.enable = true;
        delta = {
          enable = true;
          options = {
            side-by-side = true;
            line-numbers = true;
            dark = true;
            syntax-theme = "Dracula";
            true-color = "always";
          };
        };
      };

      gpg = {
        enable = true;
        mutableKeys = true;
        mutableTrust = true;
      };

      jq = {
        enable = true;
      };

      ripgrep = {
        enable = true;
      };

      starship = {
        enable = true;
        enableFishIntegration = true;
        enableTransience = true;
        settings = { 
          add_newline = true;
          continuation_prompt = "❯";
          format = "[╭─](dimmed white) $os$shell$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$dotnet$golang$java$nodejs$php$rust$conda $fill $cmd_duration$sudo$jobs$status$shlvl$singularity$kubernetes$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$elixir$elm$erlang$fennel$guix_shell$haskell$haxe$helm$julia$kotlin$gradle$lua$nim$ocaml$opa$perl$pulumi$purescript$python$raku$rlang$red$ruby$scala$solidity$swift$terraform$vlang$vagrant$zig$buf$nix_shell$meson$spack$aws$gcloud$openstack$azure$env_var$crystal$container$shell$time [─╮](dimmed white)\n[╰─](dimmed white) $character";
          right_format = "$username$hostname$localip$battery$memory_usage [─╯](dimmed white)";
          scan_timeout = 300;
          command_timeout = 2000;
          aws = {
            disabled = false;
            symbol = "  ";
          };
          battery = {
            charging_symbol = "";
            disabled = false;
            discharging_symbol = "";
            empty_symbol = "";
            full_symbol = "";
            unknown_symbol = "";
          };

          buf = {
            disabled = false;
            symbol = " ";
          };

          c = {
            disabled = false;
            symbol = " ";
          };

          character = {
            error_symbol = "[✗](bold red) ";
            success_symbol = "[❯](bold green) ";
          };

          cmake = {
            disabled = false;
            symbol = "△ ";
          };

          conda = {
            disabled = false;
            symbol = " ";
          };

          crystal = {
            disabled = false;
            symbol = " ";
          };

          dart = {
            disabled = false;
            symbol = " ";
          };

          directory = {
            disabled = false;
            fish_style_pwd_dir_length = 1;
            read_only = " 󰌾";
            truncation_length = 2;
          };

          docker_context = {
            disabled = false;
            symbol = " ";
          };

          dotnet = {
            disabled = false;
            symbol = " ";
          };

          elixir = {
            disabled = false;
            symbol = " ";
          };

          elm = {
            disabled = false;
            symbol = " ";
          };

          erlang = {
            disabled = false;
            symbol = " ";
          };

          fill = {
            style = "dimmed white";
            symbol = "•";
          };

          fossil_branch = {
            disabled = false;
            symbol = " ";
          };

          gcloud = {
            disabled = false;
            symbol = " ";
          };

          git_branch = {
            only_attached = true;
            disabled = false;
            symbol = " ";
          };

          git_commit = {
            disabled = false;
            tag_symbol = " ";
          };

          git_state = {
            format = "[\($state( $progress_current of $progress_total)\)]($style) ";
            cherry_pick = "[🍒 PICKING](bold red)";
            rebase = "[⚗️ REBASING](bold red)";
            merge = "[⚗️ MERGING](bold red)";
            revert = "[⏪ REVERTING](bold red)";
            bisect = "[🔍 BISECTING](bold red)";
            am = "[AM 📬](bold red)";
            am_or_rebase = "[AM 📬/⏪ REBASE](bold red)";
          };

          git_status = {
            ahead = " ";
            behind = " ";
            conflicted = " ";
            deleted = " ";
            disabled = false;
            diverged = " ";
            format = "([$all_status$ahead_behind]($style) )";
            modified = " ";
            renamed = " ";
            staged = " ";
            stashed = " ";
            untracked = " ";
            ignore_submodules = true;
          };

          golang = {
            disabled = false;
            symbol = " ";
          };

          guix_shell = {
            disabled = false;
            symbol = " ";
          };

          haskell = {
            disabled = false;
            symbol = " ";
          };

          haxe = {
            disabled = false;
            symbol = " ";
          };

          helm = {
            disabled = false;
            symbol = "⎈ ";
          };

          hg_branch = {
            disabled = false;
            symbol = " ";
          };

          hostname = {
            disabled = false;
            ssh_symbol = " ";
            style = "bold green";
          };

          java = {
            disabled = false;
            symbol = " ";
          };

          julia = {
            disabled = false;
            symbol = " ";
          };

          kotlin = {
            disabled = false;
            symbol = " ";
          };

          kubernetes = {
            disabled = false;
            symbol = "☸ ";
          };

          lua = {
            disabled = false;
            symbol = " ";
          };

          memory_usage = {
            disabled = false;
            symbol = "󰍛 ";
          };

          meson = {
            disabled = false;
            symbol = "󰔷 ";
          };

          nim = {
            disabled = false;
            symbol = "󰆥 ";
          };

          nix_shell = {
            disabled = false;
            symbol = " ";
          };

          nodejs = {
            disabled = false;
            symbol = " ";
          };

          openstack = {
            disabled = false;
            symbol = " ";
          };

          os = {
            disabled = false;
            symbols  = { 
              Alpaquita = " ";
              Alpine = " ";
              Amazon = " ";
              Android = " ";
              Arch = " ";
              Artix = " ";
              CentOS = " ";
              Debian = " ";
              DragonFly = " ";
              Emscripten = " ";
              EndeavourOS = " ";
              Fedora = " ";
              FreeBSD = " ";
              Garuda = "󰛓 ";
              Gentoo = " ";
              HardenedBSD = "󰞌 ";
              Illumos = "󰈸 ";
              Linux = " ";
              Mabox = " ";
              Macos = " ";
              Manjaro = " ";
              Mariner = " ";
              MidnightBSD = " ";
              Mint = " ";
              NetBSD = " ";
              NixOS = " ";
              OpenBSD = "󰈺 ";
              OracleLinux = "󰌷 ";
              Pop = " ";
              Raspbian = " ";
              RedHatEnterprise = " ";
              Redhat = " ";
              Redox = "󰀘 ";
              SUSE = " ";
              Solus = "󰠳 ";
              Ubuntu = " ";
              Unknown = " ";
              Windows = "󰍲 ";
              openSUSE = " ";
            };
          };

          package = {
            disabled = false;
            symbol = "󰏗 ";
          };

          perl = {
            disabled = false;
            symbol = " ";
          };

          php = {
            disabled = false;
            symbol = " ";
          };

          pijul_channel = {
            disabled = false;
            symbol = " ";
          };

          purescript = {
            disabled = false;
            symbol = "<≡> ";
          };

          python = {
            disabled = false;
            symbol = " ";
          };

          rlang = {
            disabled = false;
            symbol = "󰟔 ";
          };

          ruby = {
            disabled = false;
            symbol = " ";
          };

          rust = {
            disabled = false;
            symbol = " ";
          };

          scala = {
            disabled = false;
            symbol = " ";
          };

          shlvl = {
            disabled = false;
            symbol = " ";
          };

          status = {
            disabled = false;
            not_executable_symbol = " ";
            not_found_symbol = " ";
            sigint_symbol = " ";
            signal_symbol = " ";
            symbol = " ";
          };

          swift = {
            disabled = false;
            symbol = " ";
          };

          terraform = {
            disabled = false;
            symbol = "𝗧 ";
          };

          username = {
            style_user = "bold blue";
          };

          vagrant = {
            disabled = false;
            symbol = "𝗩 ";
          };

          zig = {
            disabled = false;
            symbol = " ";
          };
        };
      };

      tealdeer = {
        enable = true;
        settings = {
          display = {
            compact = false;
            use_pager = true;
          };
          updates = {
            auto_update = true;
          };
        };
      };



      btop = {
        enable = true;
        settings = {
          color_theme = "Default";
          theme_background = true;
          truecolor = true;
          force_tty = false;
          presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
          vim_keys = false;
          rounded_corners = true;
          graph_symbol = "braille";
          graph_symbol_cpu = "default";
          graph_symbol_mem = "default";
          graph_symbol_net = "default";
          graph_symbol_proc = "default";
          shown_boxes = "mem net proc cpu";
          update_ms = 2000;
          proc_sorting = "cpu direct";
          proc_reversed = false;
          proc_tree = false;
          proc_colors = true;
          proc_gradient = true;
          proc_per_core = false;
          proc_mem_bytes = true;
          proc_cpu_graphs = true;
          proc_info_smaps = false;
          proc_left = false;
          proc_filter_kernel = false;
          proc_aggregate = false;
          cpu_graph_upper = "total";
          cpu_graph_lower = "total";
          cpu_invert_lower = true;
          cpu_single_graph = false;
          cpu_bottom = false;
          show_uptime = true;
          check_temp = true;
          cpu_sensor = "Auto";
          show_coretemp = true;
          cpu_core_map = "";
          temp_scale = "celsius";
          base_10_sizes = false;
          show_cpu_freq = true;
          clock_format = "%X";
          background_update = true;
          custom_cpu_name = "";
          disks_filter = "";
          mem_graphs = true;
          mem_below_net = false;
          zfs_arc_cached = true;
          show_swap = true;
          swap_disk = true;
          show_disks = true;
          only_physical = false;
          use_fstab = false;
          zfs_hide_datasets = false;
          disk_free_priv = false;
          show_io_stat = true;
          io_mode = false;
          io_graph_combined = true;
          io_graph_speeds = "";
          net_download = 100;
          net_upload = 100;
          net_auto = true;
          net_sync = true;
          net_iface = "";
          show_battery = true;
          selected_battery = "Auto";
          show_battery_watts = true;
          log_level = "WARNING";
        };
      };

      bat = {
        enable = true;
        config = {
          theme = "Dracula";
          pager = "less -FR";
          decorations = "always";
          color = "always";
          style = "full";
          map-syntax = [
            "*.ino:C++"
            ".ignore:Git Ignore"
            "*.jenkinsfile:Groovy"
            "*.props:Java Properties"
          ];
        };
        extraPackages = with pkgs.bat-extras; [
          prettybat
          batwatch
          batpipe
          batman
          batgrep
          batdiff
        ];
        themes = {
          dracula = {
            src = pkgs.fetchFromGitHub {
              owner = "dracula";
              repo = "sublime"; # Bat uses sublime syntax for its themes
              rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
              sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
            };
            file = "Dracula.tmTheme";
          };
        };
        syntaxes = {
          gleam = {
            src = pkgs.fetchFromGitHub {
              owner = "molnarmark";
              repo = "sublime-gleam";
              rev = "2e761cdb1a87539d827987f997a20a35efd68aa9";
              hash = "sha256-Zj2DKTcO1t9g18qsNKtpHKElbRSc9nBRE2QBzRn9+qs=";
            };
            file = "syntax/gleam.sublime-syntax";
          };
        };
      };

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
          trm = "trash-rm";
          tre = "trash-empty";
          trl = "trash-list";
          trc = "trash-clear";
          trr = "trash-restore";
          trp = "trash-put";
          ":q" = "exit";
        };
        shellAliases = {
          find = "bfs";
          diff = "nvim -d";
          ls = "eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 10";
          la = "eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 100";
          cat = "bat";
          cd = "z";
          ".." = "z ..";
        };
        vendor = {
          completions.enable = true;
          config.enable = true;
          functions.enable = true;
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
        
          source ~/.config/op/plugins.sh
        '';

      };
    };
    users.defaultUserShell = pkgs.fish;
  };
}
