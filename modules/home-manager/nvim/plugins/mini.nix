{pkgs, ...}: {
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      deps.path.package = "${pkgs.unstable.vimPlugins.mini-nvim}";
      indentscope = {
        symbol = "│";
        options.try_as_border = true;
      };
    };
  };
}
