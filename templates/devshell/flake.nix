{
  description = "Project dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          # project-specific tools, e.g.:
          # go
          # sqlc
          # postgresql # just the client tools
        ];

        # env vars, e.g.:
        # DATABASE_URL = "postgres://localhost:5432/dev";
      };
    };
}
