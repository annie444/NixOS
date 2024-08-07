# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    kubernetes-helm-wrapped = prev.wrapHelm prev.kubernetes-helm {
      plugins = with prev.kubernetes-helmPlugins; [
        helm-diff
        helm-secrets
        helm-s3
        helm-git
      ];
    };
  };

  nvidia-overlay = (final: prev:
  let
    inherit (prev.pkgs) callPackage;
    virtualization = prev.pkgs.path + "/pkgs/applications/virtualization";
    unpatched-nvidia-driver = (prev.pkgs.linuxKernel.packages.linux_5_15.nvidia_x11_production.overrideAttrs (oldAttrs: {
      builder = ../overlays/nvidia-builder.sh;
    }));
  in
  {
    # cudaPackages = prev.cudaPackages // {
    #   fabricmanager = prev.cudaPackages.fabricmanager.overrideAttrs (oldAttrs: {
    #     version = "525.85.12";
    #     linux-x86_64 = {
    #       relative_path = "fabricmanager/linux-x86_64/fabricmanager-linux-x86_64-525.85.12-archive.tar.xz";
    #       sha256 = "0x0czlzhh0an6dh33p84hys4w8nm69irwl30k1492z1lfflf3rh1";
    #     };
    #   });
    # };

    libnvidia-container = import ./libnvidia-container.nix {
      inherit (final) stdenv lib;
      inherit (final.pkgs)
        addOpenGLRunpath fetchFromGitHub glibc pkg-config
        libelf libcap libseccomp libtirpc rpcsvc-proto
        makeWrapper substituteAll removeReferencesTo go;
      inherit (final.pkgs.cudaPackages) fabricmanager;
      inherit unpatched-nvidia-driver;
    };

    nvidia-container-toolkit = import ./nvidia-container-toolkit.nix {
      inherit (final) lib;
      inherit (final.pkgs)
        addOpenGLRunpath
        glibc fetchFromGitLab makeWrapper buildGoPackage
        linkFarm writeShellScript
        libnvidia-container;
      inherit unpatched-nvidia-driver;

      containerRuntimePath = "runc";
      configTemplate = ./config.toml;
    };

    nvidia-k3s = final.pkgs.symlinkJoin {
      name = "nvidia-k3s";
      paths = [
        final.libnvidia-container
        final.nvidia-container-toolkit
      ];
    };
  });

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
