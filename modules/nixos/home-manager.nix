# Bridges Home Manager into the NixOS build; per-user config lives in home/.
{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    # If a target dotfile already exists, move it aside instead of aborting.
    backupFileExtension = "hm-backup";
    users.marcus = import ../../home/marcus;
  };
}
