# User accounts and their login shells.
{ pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.marcus = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
