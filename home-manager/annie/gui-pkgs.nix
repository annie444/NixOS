{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}: {

  imports = [
    outputs.homeManagerModules.kitty
  ];

  profiles.kitty.enable = true;

  home.packages = with pkgs; [
    firefox
    thunderbird
    slack
    slack-cli
    _1password
    _1password-gui
    neovim-qt
    neovim-remote
  ];
}
