{ inputs, ... }: {
  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
  environment.systemPackages = [ inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}

