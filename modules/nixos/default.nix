# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  homelab = import ./homelab;
  gui = import ./gui.nix;
  k3s-cuda = import ./k3s-cuda.nix;
  cuda = import ./cuda.nix;
  nvidia-graphics = import ./nvidia-graphics.nix;
}
