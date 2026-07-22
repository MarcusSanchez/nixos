{
  description = "Marcus's NixOS configuration (WSL)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      # `nix fmt` formats the whole tree
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      # Scaffold a per-project dev shell: nix flake init -t /etc/nixos
      templates.default = {
        path = ./templates/devshell;
        description = "mkShell dev environment with direnv auto-load";
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/wsl ];
      };
    };
}
