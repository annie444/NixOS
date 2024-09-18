{pkgs, ...}:
pkgs.tree-sitter.buildGrammar {
  language = "amber";
  version = "2024-08-13";
  generate = true;
  src = pkgs.fetchFromGitHub {
    owner = "amber-lang";
    repo = "tree-sitter-amber";
    rev = "e75c9ddd5cb5048826b480328bca0579ca986611";
    hash = "sha256-SNb294cPdNh11wU3m3soQKuC/k/abXfymqc8fUpyYz0=";
  };
  meta.homepage = "https://github.com/amber-lang/tree-sitter-amber";
}
