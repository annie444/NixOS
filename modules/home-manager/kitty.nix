{ config, pkgs, lib, ... }:

with lib;

let cfg = config.profiles.kitty; in {

  imports = [];

  options.profiles.kitty.enable = mkEnableOption "Enable kitty shell";

  config = mkIf cfg.enable {

    fonts.fontconfig.enable = true;

    programs.kitty = {

      enable = true;

      shellIntegration = {
        enableFishIntegration = true;
        mode = "no-title no-cwd";
      };

      font = {
        name = "JetBrainsMono Nerd Font Mono";
        package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
        size = 12;
      };

      keybindings = {
        "opt+w" = "detach_window";
        "opt+t" = "detach_window new-tab";
        "opt+b" = "detach_window tab-prev";
        "ctrl+opt+h" = "detach_window tab-left";
        "ctrl+opt+shift+h" = "detach_window new-tab-left";
        "opt+d" = "detach_window ask";

        "kitty_mod+-" = "launch --location=hsplit";
        "kitty_mod+\\" = "launch --location=vsplit";
        "kitty_mod+s" = "launch --location=split";
        "kitty_mod+r" = "layout_action rotate";
        "opt+k" = "move_window up";
        "opt+j" = "move_window down";
        "opt+h" = "move_window left";
        "opt+shift+j" = "layout_action move_to_screen_edge bottom";
        "opt+shift+l" = "layout_action move_to_screen_edge right";
        "opt+shift+h" = "layout_action move_to_screen_edge left";
        "opt+shift+k" = "layout_action move_to_screen_edge up";
        "super+h" = "neighboring_window left";
        "super+k" = "neighboring_window up";
        "super+j" = "neighboring_window down";
        "super+l" = "neighboring_window right";
        "kitty_mod+h" = "previous_tab";
        "kitty_mod+l" = "next_tab";
        "kitty_mod+." = "new_tab_with_cwd";
        "kitty_mod+x" = "close_tab";

        "kitty_mod+v" = "paste_from_clipboard";
        "kitty_mod+c" = "copy_to_clipboard";
        "ctrl+c" = "copy_and_clear_or_interrupt";
        "opt+left" = "resize_window narrower";
        "opt+right" = "resize_window wider";
        "opt+up" = "resize_window taller";
        "opt+down" = "resize_window shorter 3";
        "opt+r" = "resize_window reset";
      };

      settings = {
        background_opacity = "0.9";
        dynamic_background_opacity = "yes";
        background_blur = 20;
        window_padding_width = 4;
        adjust_line_height = "110%";
        allow_remote_control = "yes";
        enabled_layouts = "splits";
        tab_bar_min_tabs = 1;
        listen_on_unix = "/tmp/mykitty";
        tab_bar_edge = "top";
        tab_bar_style = "separator";
        tab_separator = "|";
        tab_title_template = "{fmt.fg._bd93f9}{index}:{fmt.fg.tab}{title.split()[0]}";
        active_tab_title_template = "";
        active_tab_font_style = "bold-italic";
        inactive_tab_font_style = "normal";
        tab_bar_margin_width = "0.5";
        tab_bar_margin_height = "1.0 0.5";
        font_features = "+liga +calt +dlig +frac +ordn +subs +sups";
        kitty_mod = "ctrl+shift";
      };

      theme = "Dracula";
    };

  };
}
