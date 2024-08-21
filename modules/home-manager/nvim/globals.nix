{pkgs, ...}: {
  mapleader = " ";
  mkdp_auto_close = "false";
  tex_compiles_successfully = "false";
  term_pdf_vierer_open = "false";
  tex_flavor = "latex";
  tex_conceal = "abdmgs";
  vimtex_quickfix_mode = 0;
  vimtex_compiler_latexmk_engines = {
    "_" = "-pdflatex";
  };
  vimtex_view_enabled = 0;
  vimtex_view_automatic = 0;
  vscode_snippets_path = "vim.fn.stdpath(\"config\") .. \"/snippets/vscode\"";
  lua_snippets_path = "vim.fn.stdpath(\"config\") .. \"/lua/custom/lua_snippets\"";
  magma_image_provider = "kitty";
  magma_automatically_open_output = "true";
  magma_wrap_output = "false";
  magma_output_window_borders = "false";
  magma_cell_highlight_group = "CursorLine";
  magma_save_path = "vim.fn.stdpath(\"data\") .. \"/magma\"";
  vim_svelte_plugin_load_full_syntax = 1;
  python3_host_prog = "${pkgs.python311}/bin/python";
  ruby_host_prog = "${pkgs.ruby}/bin/ruby";
  node_host_prog = "${pkgs.nodePackages_latest.nodejs}/bin/node";
  perl_host_prog = "${pkgs.perl}/bin/perl";
  copilot_assume_mapped = "true";
  vimwiki_list = [
    {
      path = "~/Documents/Notes";
      path_html = "~/Documents/Notes/HTML/";
      syntax = "markdown";
      ext = ".md";
    }
  ];
  vimwiki_url_maxsave = 0;
}
