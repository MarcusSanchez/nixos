# Claude Code, kept current via the claude-code-nix overlay (has a binary cache).
{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];

  environment.systemPackages = [ pkgs.claude-code ];
}
