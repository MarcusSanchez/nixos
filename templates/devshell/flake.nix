{
  description = "Project dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      # Every platform current nixpkgs supports, not just the machines this
      # template came from — so collaborators (ARM linux, any mac) can
      # direnv in too. (No x86_64-darwin: nixpkgs 26.11 dropped Intel macs.)
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # project-specific tools, e.g.:
              # go
              # sqlc
              # postgresql # just the client tools
            ];

            # env vars, e.g.:
            # DATABASE_URL = "postgres://localhost:5432/dev";
          };
        }
      );
    };
}
