{ pkgs, ... }: {
  treesitter-amber = pkgs.tree-sitter.buildGrammar {
    language = "amber";
    version = "*";
    src = pkgs.fetchFromGitHub {
      owner = "amber-lang";
      repo = "tree-sitter-amber";
    };
    meta.homepage = "https://github.com/amber-lang/tree-sitter-amber";
  };
}
