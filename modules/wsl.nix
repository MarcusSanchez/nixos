{ inputs, ... }:

{
  imports = [ inputs.nixos-wsl.nixosModules.default ];
  wsl.enable = true;
  wsl.defaultUser = "marcus";
  system.stateVersion = "25.05";
}

