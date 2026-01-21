{ inputs, ... }:

{
  imports = [ inputs.nixos-wsl.nixosModules.default ];
  wsl.enable = true;
  wsl.defaultUser = "sugar";
  system.stateVersion = "25.05";
}

