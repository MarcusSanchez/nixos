# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Flake-based NixOS configuration for a single WSL machine (host `nixos`, user `marcus`). The repo lives at `~/nixos-config`; `/etc/nixos` is a symlink to it, which is what `nixos-rebuild` and `system.autoUpgrade` (weekly, against the lockfile) rely on.

## Commands

```sh
sudo nixos-rebuild switch --flake /etc/nixos   # apply config (passwordless sudo works here)
nix flake check                                # validate before switching — always do this after edits
nix fmt                                        # format all nix files (nixfmt-tree)
nix flake update                               # bump all inputs (autoUpgrade never does this)
```

There are no tests; `nix flake check` (evaluation) plus a successful switch is the verification story.

## Architecture

Three layers, wired together in `flake.nix` via flake-parts. Flake inputs are passed everywhere as `specialArgs`/`extraSpecialArgs`, so any module can take `inputs` as an argument.

1. `hosts/wsl/default.nix` — the only entry in `flake.nix`. Holds host-specific values (hostname, `system.stateVersion`) and imports layer 2.
2. `modules/nixos/` — system-level, one concern per file. `default.nix` is the aggregator: **a new module does nothing until added to its imports list.** `home-manager.nix` bridges to layer 3 (Home Manager as NixOS module, `backupFileExtension = "hm-backup"`).
3. `home/marcus/` — per-user Home Manager modules, imported by `home/marcus/default.nix`.

Where things go: system package → `modules/nixos/packages.nix`; user CLI tool → `home/marcus/packages.nix`; new concern (docker, postgres, ...) → new file in `modules/nixos/` + aggregator entry.

## Constraints that are easy to violate

- **Never manage `~/.config/nvim` through Nix, and never re-enable `programs.neovim`.** It is marcus's own LazyVim fork (github.com/marcussanchez/neovim-config), a normal mutable git checkout — lazy.nvim writes `lazy-lock.json` and marcus commits/pushes from there. `programs.neovim` generates its own `init.lua` and symlinks it over the checkout, silently breaking the whole editor (this happened once; the fix was deliberate). `home/marcus/neovim.nix` installs the nightly binary via `home.packages` and clone-bootstraps the config only if `~/.config/nvim` doesn't exist.
- **Zig's version is pinned in two places that must move together**: the attribute name `"0.16.0"` in `modules/nixos/zig.nix` (selects from the zig-overlay catalog) and the ref in the `zls-overlay` input URL in `flake.nix`. ZLS is built with that exact Zig via `overrideAttrs`, so bumping one without the other breaks the compiler/LSP match.
- **`system.stateVersion` and `home.stateVersion` (both "25.05") must never change** — they are not "the version we're on".
- The zsh `initContent` in `home/marcus/shell.nix` is wrapped in `lib.mkOrder 1200` on purpose, so marcus's keybindings land after zoxide/atuin's shell hooks. Don't drop the ordering when editing it.
