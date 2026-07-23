# Standalone user-level tools.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    croc
    flyctl
  ];
}
