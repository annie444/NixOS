{pkgs, ...}:
pkgs.tree-sitter.buildGrammar {
  language = "just";
  version = "2024-07-29";
  src = pkgs.fetchFromGitHub {
    owner = "IndianBoy42";
    repo = "tree-sitter-just";
    rev = "6648ac1c0cdadaec8ee8bcf9a4ca6ace5102cf21";
    hash = "sha256-EVISh9r+aJ6Og1UN8bGCLk4kVjS/cEOYyhqHF40ztqg=";
  };
  meta.homepage = "https://github.com/IndianBoy42/tree-sitter-just";
}
