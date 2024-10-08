{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.templates.services.tailscale;
in {
  options.templates.services.tailscale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable tailscale services.";
    };
    autoconnect = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable tailscale autoconnect services.";
      };
      key = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "tailscale autoconnect key.";
      };
      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "tailscale autoconnect key file path.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
    };

    environment = {
      systemPackages = with pkgs; [
        tailscale
      ];
    };

    systemd.services.tailscale-autoconnect = lib.mkIf cfg.autoconnect.enable {
      description = "Automatic connection to Tailscale";
      after = ["network-pre.target" "tailscale.service"] ++ lib.optionals (cfg.autoconnect.keyFile != null && cfg.autoconnect.keyFile != "") ["sops-nix.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "oneshot";
      script =
        if ((cfg.autoconnect.key != "") && (cfg.autoconnect.key != null))
        then ''
          sleep 3

          # check if we are already authenticated to tailscale
          status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then
            exit 0
          fi

          # authenticate with tailscale
          ${pkgs.tailscale}/bin/tailscale up -authkey ${cfg.autoconnect.key}
        ''
        else ''
          sleep 3

          # check if we are already authenticated to tailscale
          status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then
            exit 0
          fi

          # authenticate with tailscale
          ${pkgs.tailscale}/bin/tailscale up -authkey $(cat ${cfg.autoconnect.keyFile})
        '';
    };
  };
}
