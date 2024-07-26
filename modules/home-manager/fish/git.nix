{ config, outputs, pkgs, lib, ... }:

with lib;

let
  cfg = config.profiles.git;
in 
{
  options.profiles.git = {
    enable = mkEnableOption "enable git profile";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git
    ];
    programs.git = {
      enable = true;
      userName = "Annie Ehler";
      userEmail = "annie.ehler.4@gmail.com";
      aliases = {
        a = "add";
        aa = "add --all";
        amend = "commit --amend --no-edit";
        c = "commit";
        ca = "commit -a";
        cam = "commit -a -m";
        cm = "commit -m";
        co = "checkout";
        cob = "checkout -b";
        com = "checkout master";
        d = "diff";
        dc = "diff --cached";
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";
        pl = "pull";
        pu = "push";
        puf = "push --force";
        r = "reset HEAD";
        r1 = "reset HEAD^";
        r2 = "reset HEAD^^";
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        rbi = "rebase --interactive";
        rbs = "rebase --skip";
        rhard = "reset --hard";
        rhard1 = "reset HEAD^ --hard";
        rhard2 = "reset HEAD^^ --hard";
        rs = "restore --staged";
        s = "status";
        sd = "stash drop";
        spo = "stash pop";
        spu = "stash push";
        spua = "stash push --all";
      };
      signing = {
        key = "annie.ehler.4@gmail.com";
        signByDefault = true;
      };
      lfs.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        merge.conflictStyle = "diff3";
      };
      delta = {
        enable = true;
        options = {
          side-by-side = true;
          line-numbers = true;
          dark = true;
          syntax-theme = "Dracula";
          true-color = "always";
        };
      };
    };
  };
}
