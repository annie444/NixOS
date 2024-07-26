{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.gh;
in 
{
  options.profiles.gh = {
    enable = mkEnableOption "enable gh profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gh-dash
    ];
    programs = {
      gh-dash.enable = true;

      gh = {
        enable = true;
        settings = {
          aliases = {
            icl = "issue close";
            icr = "issue create";
            il = "issue list";
            ire = "issue reopen";
            iv = "issue view";
            ivw = "issue view --web";
            pck = "pr checks";
            pcl = "pr close";
            pco = "pr checkout";
            pcr = "pr create";
            pd = "pr diff";
            pl = "pr list";
            pm = "pr merge";
            pre = "pr reopen";
            pv = "pr view";
            pvw = "pr view --web";
            rcl = "repo clone";
            rcr = "repo create";
            rfk = "repo fork --clone --remote";
            rv = "repo view";
            rvw = "repo view --web";
          };
          editor = "nvim";
          git_protocol = "ssh";
          prompt = "enabled";
        };
        gitCredentialHelper = {
          enable = true;
          hosts = [
            "https://github.com"
            "https://gist.github.com"
          ];
        };
      };
    };
  };
}
