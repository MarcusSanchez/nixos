# Nix daemon settings, garbage collection, and automatic upgrades.
{ ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  # Automatic cleanup
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  # Automatic updating: rebuilds /etc/nixos weekly, honouring flake.lock.
  # Run `nix flake update` to actually bump inputs.
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flake = "/etc/nixos";
  };

  nixpkgs.config.allowUnfree = true;
}
