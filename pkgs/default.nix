# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  abbreviation-tips = pkgs.callPackage ./abbreviation-tips { };
  dracula = pkgs.callPackage ./dracula { };
  gitnow = pkgs.callPackage ./gitnow { };
  spark = pkgs.callPackage ./spark { };
}
