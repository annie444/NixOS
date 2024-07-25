{ ... }: {
  users.users = {
    annie = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
	      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVVe3niALKXj/d7z0Bn27uF5e64GfjPgcWOXXwziJpW"
	      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvhfZJ3pXA5ZJ3+6PPI6NxvOg5E/y3kKZ1NxkfTKZoD"
      ];
      extraGroups = ["wheel"];
    };
  };
}
