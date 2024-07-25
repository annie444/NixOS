{ config, pkgs, lib, ... }:

with lib;

let cfg = config.tmux; in {
  options.tmux.enable = mkEnableOption "tmux profile";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      extraConfigBeforePlugins = "set -g mouse on";
      keyMode = "vi";
      newSession = true;
      shortcut = "Space";
      aggressiveResize = true;
      escapeTime = 0;
      historyLimit = 20000;
      extraConfig = builtins.readFile ./tmux.conf;
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        yank
        weather
        tmux-fzf
        resurrect
        prefix-highlight
        battery
        sysstat
        copycat
        {
          plugin = sidebar;
          extraConfig = ''
            set -g @sidebar-tree 't'
            set -g @sidebar-tree-focus 'T'
            set -g @sidebar-tree-command 'tree -C'
          '';
        }
        {
          plugin = open;
          extraConfig = ''
            set -g @open-S 'https://www.google.com/search?q='
          '';
        }
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "battery cpu-usage ram-usage network-bandwidth git ssh-session weather time"

            # Color options ([background] [foreground/text])
            set -g @dracula-battery-colors "pink dark_gray"
            set -g @dracula-cpu-usage-colors "orange dark_gray"
            set -g @dracula-ram-usage-colors "cyan dark_gray"
            set -g @dracula-network-bandwidth-colors "green dark_gray"
            set -g @dracula-git-colors "dark_purple white"
            set -g @dracula-ssh-session-colors "red dark_gray"
            set -g @dracula-attached-clients-colors "yellow dark_gray"
            set -g @dracula-weather-colors "light_purple dark_gray"
            set -g @dracula-time-colors "white dark_gray"
            set -g @dracula-synchronize-panes-colors "dark_gray white"

            # Display options
            set -g @dracula-show-powerline true
            set -g @dracula-show-left-sep  
            set -g @dracula-show-right-sep  
            set -g @dracula-show-flags true
            set -g @dracula-show-empty-plugins false
            set -g @dracula-show-left-icon shortname
            set -g @dracula-refresh-rate 2
            set -g @dracula-left-icon-padding 1
            set -g @dracula-border-contrast true

            # CPU usage options
            set -g @dracula-cpu-usage-label ""
            set -g @dracula-cpu-display-load true

            # Battery options
            set -g @dracula-battery-label "󰁹"
            set -g @dracula-show-battery true

            # RAM useage options
            set -g @dracula-ram-usage-label ""

            # Network options
            set -g @dracula-network-bandwidth-interval 2
            set -g @dracula-network-bandwidth-show-interface true

            # SSH options
            set -g @dracula-show-ssh-session-port false

            # Time options
            set -g @dracula-show-timezone true
            set -g @dracula-day-month false
            set -g @dracula-military-time true
            set -g @dracula-time-format "%a, %b %d, %Y at %H:%M"

            # Version control options
            set -g @dracula-git-disable-status true
            set -g @dracula-git-show-current-symbol ✓
            set -g @dracula-git-show-diff-symbol !
            set -g @dracula-git-no-repo-message ""
            set -g @dracula-git-no-untracked-files true
            set -g @dracula-git-show-remote-status true
            set -g @dracula-hg-disable-status true
            set -g @dracula-hg-show-current-symbol ✓
            set -g @dracula-hg-show-diff-symbol !
            set -g @dracula-hg-no-repo-message ""
            set -g @dracula-hg-no-untracked-files true

            # Weather options
            set -g @dracula-show-fahrenheit true
            set -g @dracula-fixed-location "Los Angeles, CA"
            set -g @dracula-show-location false

            # Panes options
            set -g @dracula-synchronize-panes-label "󰓦"

            # TMUX clients options
            set -g @dracula-clients-minimum 2
            set -g @dracula-clients-singular client
            set -g @dracula-clients-plural clients
          '';
        }
        sensible
      ]
    };

  };
}
