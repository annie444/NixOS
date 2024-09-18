# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # add your custom packages here
  # example:
  treesitter-amber = pkgs.callPackage ./treesitter-amber.nix {};
  noice = pkgs.callPackage ./noice.nix {};
}
