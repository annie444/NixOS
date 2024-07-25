{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.starship;
in 
{
  options.profiles.starship = {
    enable = mkEnableOption "enable starship profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      starship
    ];
    programs.starship = {
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
  };
}
