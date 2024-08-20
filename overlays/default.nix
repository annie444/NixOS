# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    kubernetes-helm-wrapped = prev.wrapHelm prev.kubernetes-helm {
      plugins = with prev.kubernetes-helmPlugins; [
        helm-diff
        helm-secrets
        helm-s3
        helm-git
      ];
    };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable (with final; {
      inherit system;
      config.allowUnfree = true;
    });
  };
}
