{pkgs, ...}: {
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    enableDiagnostics = true;
    enableGitStatus = true;
    enableModifiedMarkers = true;
    enableRefreshOnWrite = true;
    addBlankLineAtTop = false;
    autoCleanAfterSessionRestore = true;
    closeIfLastWindow = true;
    defaultSource = "filesystem";
    gitStatusAsync = true;
    hideRootNode = false;
    iconsPackage = pkgs.vimPlugins.nvim-web-devicons;
    popupBorderStyle = "rounded";
    sortCaseInsensitive = true;
    defaultComponentConfigs = {
      container.enableCharacterFade = true;
      indent = {
        indentSize = 2;
        padding = 1;
        withMarkers = true;
        indentMarker = "│";
        lastIndentMarker = "└";
        highlight = "NeoTreeIndentMarker";
        expanderCollapsed = "";
        expanderExpanded = "";
        expanderHighlight = "NeoTreeExpander";
      };
      icon = {
        folderClosed = "";
        folderOpen = "";
        folderEmpty = "󰜌";
        default = "*";
        highlight = "NeoTreeFileIcon";
      };
      modified = {
        symbol = "[]";
        highlight = "NeoTreeModified";
      };
      name = {
        trailingSlash = false;
        useGitStatusColors = true;
        highlight = "NeoTreeFileName";
      };
      gitStatus = {
        symbols = {
          added = "✚";
          modified = "";
          deleted = "✖";
          renamed = "󰁕";
          untracked = "";
          ignored = "";
          unstaged = "󰄱";
          staged = "";
          conflict = "";
        };
      };
    };
  };
}
