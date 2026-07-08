# Home Manager entry point for marcus.
{ ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./neovim.nix
    ./git.nix
    ./catppuccin.nix
  ];

  home.username = "marcus";
  home.homeDirectory = "/home/marcus";

  home.sessionVariables = {
    SUDO_EDITOR = "nvim";
  };

  # Do not change after initial install.
  home.stateVersion = "25.05";
}
