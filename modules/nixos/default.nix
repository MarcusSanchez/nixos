# Aggregator for all system-level modules.
{ ... }:

{
  imports = [
    ./nix.nix
    ./packages.nix
    ./nix-ld.nix
    ./users.nix
    ./wsl.nix
    ./home-manager.nix
    ./claude-code.nix
    ./zig.nix
  ];
}
