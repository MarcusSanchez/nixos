# User-level nix housekeeping on the mac. System-side nix management is off
# (Determinate Nix owns the daemon — see modules/darwin/nix.nix), so GC runs
# as the user (launchd agent); the daemon still deletes unreferenced store
# paths on its behalf.
{ config, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # Bare `nh darwin switch` finds the flake (the repo lives at ~/nix-config
  # on the mac, symlinked to /etc/nix-darwin for darwin-rebuild)
  home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/nix-config";
}
