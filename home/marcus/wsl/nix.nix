# User-level nix housekeeping on WSL: let bare `nh os switch` find the
# flake without a path argument. (GC and autoUpgrade are system-side here,
# in modules/nixos/nix.nix; the mac counterpart of this file is
# ../mac/nix.nix.)
{ ... }:

{
  home.sessionVariables.NH_FLAKE = "/etc/nixos";
}
