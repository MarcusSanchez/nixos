# Home Manager entry point for the WSL machine: shared config + Linux bits.
{ ... }:

{
  imports = [
    ./common
    ./wsl/toolchains.nix
  ];

  home.username = "marcus";
  home.homeDirectory = "/home/marcus";
}
