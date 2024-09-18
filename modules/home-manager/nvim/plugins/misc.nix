{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    lsp-lines.enable = true;
    lazygit.enable = true;
    indent-blankline.enable = true;
    web-devicons.enable = true;
    ts-autotag.enable = true;
    ts-context-commentstring.enable = true;
    treesitter-refactor.enable = true;
    schemastore.enable = true;
    nvim-jdtls = {
      enable = true;
      cmd = [
        (lib.getExe pkgs.jdt-language-server)
        "-data"
        "/path/to/your/workspace"
        "-configuration"
        "/path/to/your/configuration"
        "-foo"
        "bar"
      ];
    };
    vim-bbye.enable = true;
    markdown-preview.enable = true;
    diffview.enable = true;
    direnv.enable = true;
    vimtex.enable = true;
    lsp-format.enable = true;
  };
}
