{pkgs, ...}: {
  noice-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "noice";
    src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "noice.nvim";
    };
  };
}
