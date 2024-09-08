{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.templates.system.grub;
in {
  options.templates.system.grub = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Desktop services.";
    };
  };

  config = lib.mkIf cfg.enable {
    loader.grub = {
      enable = true;
      device = "nodev";
      backgroundColor = "#282A36";
      efiSupport = true;
      memtest86.enable = true;
      copyKernels = true;
    };
  };
}
