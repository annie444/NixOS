{pkgs, ...}:
pkgs.vimUtils.buildVimPlugin {
  pname = "noice";
  version = "4.5.0";
  src = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "noice.nvim";
    rev = "448bb9c524a7601035449210838e374a30153172";
    hash = "sha256-86oWl3XGuuVhaWVe6egjc7Mt8Pp7qpTMJ2EZiNlztt8=";
  };
}
