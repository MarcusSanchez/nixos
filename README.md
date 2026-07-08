# nixos-config

Flake-based NixOS configuration for a single WSL machine (host `nixos`, user `marcus`).

The repo lives at `~/nixos-config`; `/etc/nixos` is a symlink to it, so both
`nixos-rebuild` and `system.autoUpgrade` find it without extra flags.

## Layout

```
flake.nix                  Inputs + host wiring (flake-parts)
hosts/
  wsl/default.nix          Host-specific: hostname, stateVersion
modules/nixos/             System-level modules (one concern per file)
  default.nix              Aggregator — imports everything below
  nix.nix                  Nix settings, GC, auto-upgrade
  packages.nix             System dev toolchains (go, rust, node, ...)
  nix-ld.nix               Run unpatched dynamic binaries on NixOS
  users.nix                User accounts + login shell
  wsl.nix                  NixOS-WSL integration
  home-manager.nix         Bridges Home Manager; points at home/marcus
  claude-code.nix          Claude Code (claude-code-nix overlay)
  zig.nix                  Zig 0.16.0 + matching ZLS
home/marcus/               Home Manager (per-user) modules
  default.nix              Entry point — identity, stateVersion, imports
  packages.nix             Standalone user tools
  shell.nix                zsh + oh-my-zsh, zoxide, atuin
  neovim.nix               Neovim nightly; clones marcussanchez/neovim-config
                           to ~/.config/nvim on first activation (stays a
                           normal mutable git checkout, not nix-managed)
  git.nix                  Git identity + gh
  catppuccin.nix           Catppuccin Mocha theming
```

## Common operations

```sh
# Apply the configuration
sudo nixos-rebuild switch --flake /etc/nixos

# Update all inputs, then apply
nix flake update
sudo nixos-rebuild switch --flake /etc/nixos

# Format all nix files
nix fmt

# Sanity-check without switching
nix flake check
```

Auto-upgrade rebuilds this flake weekly against its lockfile; inputs only
move when you run `nix flake update`. Garbage collection runs daily and
keeps the last 10 days.

## Adding things

- A system package → `modules/nixos/packages.nix`
- A user CLI tool → `home/marcus/packages.nix`
- A new concern (e.g. docker, postgres) → new file in `modules/nixos/`,
  then add it to `modules/nixos/default.nix`
- A second host → new directory under `hosts/`, new entry in `flake.nix`,
  reusing `modules/nixos` and picking per-host modules as needed
