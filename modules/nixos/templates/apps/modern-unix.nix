{
  lib,
  config,
  pkgs,
  outputs,
  ...
}: let
  cfg = config.templates.apps.modernUnix;
in {
  options.templates.apps.modernUnix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Add modern-unix tools.";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = {
      overlays = [
        outputs.overlays.unstable-packages
      ];
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "unrar"
        ];
    };
    environment = {
      systemPackages = with pkgs; [
        age
        bat
        bc
        choose
        coreutils-full
        curlie
        delta
        dogdns
        du-dust
        duf
        fd
        file
        fzf
        lftp
        wget
        inetutils
        gping
        icoutils
        jq
        ncdu
        restic
        p7zip
        kubectl
        lf
        lsd
        mcfly
        mediainfo
        unstable.helix
        unstable.yazi
        openssl
        parallel
        pciutils
        procs
        rclone
        ripgrep
        rsync
        sd
        smbnetfs
        sops
        sshfs
        starship
        tmux
        trash-cli
        tree
        unrar
        unzip
        usbutils
        zellij
        zoxide
        vault-medusa
        zip
      ];
    };
  };
}
