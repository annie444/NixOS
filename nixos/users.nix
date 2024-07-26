{ pkgs, inputs, ... }: {

  sops.secrets."annie/password".neededForUsers = true;

  programs.fish.enable = true;

  users.users = {
    annie = {
      hashedPasswordFile = sops.secrets."annie/password".path;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
	      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVVe3niALKXj/d7z0Bn27uF5e64GfjPgcWOXXwziJpW"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvhfZJ3pXA5ZJ3+6PPI6NxvOg5E/y3kKZ1NxkfTKZoD"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTijhGkE4C7yFWj0/md4R8EwLaYsyHKLTIOzJM65QHv"
      ];
      extraGroups = ["wheel"];
      shell = pkgs.fish;
    };
  };
}
