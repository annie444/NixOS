{
  project-nvim = {
    enable = true;
    enableTelescope = true;
    settings = {
      manual_mode = false;
      detection_methods = [ "pattern" "lsp" ];
      patterns = [
        ".git"
        ".vscode"
        ".svn"
        "Makefile"
        "package.json" 
        "pyproject.toml"
        "Cargo.toml"
        "setup.py"
        "go.mod"
      ];
      show_hidden = false;
      silent_chdir = true;
      scope_chdir = "global";
    };
  };
}
