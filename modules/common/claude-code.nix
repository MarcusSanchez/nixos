# Claude Code, kept current via the claude-code-nix overlay. Its binary
# cache (claude-code.cachix.org) is wired in per-platform: nix.settings in
# modules/nixos/nix.nix on WSL, /etc/nix/nix.custom.conf on the mac.
{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];

  environment.systemPackages = [ pkgs.claude-code ];
}
