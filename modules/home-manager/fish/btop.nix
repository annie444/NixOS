{
  config,
  outputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.profiles.btop;
in {
  options.profiles.btop = {
    enable = mkEnableOption "enable btop profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      btop
    ];
    programs.btop = {
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
