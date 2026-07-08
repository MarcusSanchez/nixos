# Host definition: the WSL machine. Everything host-specific lives here;
# everything reusable lives in modules/.
{ ... }:

{
  imports = [ ../../modules/nixos ];

  networking.hostName = "nixos";

  # Do not change after initial install.
  system.stateVersion = "25.05";
}
