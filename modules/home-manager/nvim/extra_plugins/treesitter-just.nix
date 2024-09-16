{ pkgs, ... }: {
    treesitter-just = pkgs.tree-sitter.buildGrammar {
    language = "just";
    version = "*";
    src = pkgs.fetchFromGitHub {
      owner = "IndianBoy42";
      repo = "tree-sitter-just";
    };
    meta.homepage = "https://github.com/IndianBoy42/tree-sitter-just";
  };
}
