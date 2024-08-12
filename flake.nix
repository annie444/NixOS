{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    nur.url = "github:nix-community/NUR";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    disko,
    nur,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    baseSystem = [
      nur.nixosModules.nur
      disko.nixosModules.disko
      ./nixos/configuration.nix
    ];

    nixpkgs = {
      overlays = import ./overlays {inherit inputs;};
      config = {
        allowUnfree = true;
      };
    };

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixpkgs = {
      overlays = import ./overlays {inherit inputs;};
      config = {
        allowUnfree = true;
      };
    };

    nixosConfigurations = {
      homelab01 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          [
            # > Our main nixos configuration file <
            ./nixos/homelab01/configuration.nix
            ./nixos/homelab01/disko-config.nix
          ]
          ++ baseSystem;
      };
      homelab02 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          [
            # > Our main nixos configuration file <
            ./nixos/homelab02/configuration.nix
            ./nixos/homelab02/disko-config.nix
          ]
          ++ baseSystem;
      };
      spinoza = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          [
            # > Our main nixos configuration file <
            ./nixos/spinoza/configuration.nix
            ./nixos/spinoza/disko-config.nix
          ]
          ++ baseSystem;
      };
    };

    homeConfigurations = {
      "annie-no-gui" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/annie/home.nix
        ];
      };
      "annie-gui" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/annie/home.nix
          ./home-manager/annie/gui.nix
        ];
      };
    };
  };
}
