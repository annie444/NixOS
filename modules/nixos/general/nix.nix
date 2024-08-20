{
  nix = {
    # TODO enable this when all machines are updated
    # package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    optimise = {
      automatic = true;
      dates = ["20:00"];
    };
  };
}
