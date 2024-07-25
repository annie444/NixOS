# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  boot.loader.systemd-boot.enable = true;
  boot.crashDump.enable = true;
  boot.enableContainers = true;
  boot.initrd.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.backgroundColor = "#282A36";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.memtest86.enable = true;
  boot.plymouth.enable = true;
  boot.supportedFilesystems = {
    btrfs = true;
    zfs = true;
  };
  boot.swraid.enable = true;
  boot.tmp.cleanOnBoot = true;
  
  networking.useDHCP = lib.mkDefault true;

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}
