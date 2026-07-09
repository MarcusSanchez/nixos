# Stable toolchain paths for IDEs, plus the rustup repair hook.
#
# JetBrains resolves symlinks and pins the resulting /nix/store path, which
# goes stale on upgrade. Pin these ~/.toolchains paths in the IDE instead:
# they retarget on every rebuild, and their targets can't be garbage
# collected while the generation is live.
{ pkgs, lib, ... }:

{
  home.file.".toolchains/go".source = "${pkgs.go}/share/go"; # GOROOT
  home.file.".toolchains/node".source = pkgs.nodejs_latest;
  home.file.".toolchains/buf".source = pkgs.buf;

  # rustup-downloaded toolchains are patched against one specific store
  # glibc; when an upgrade bumps glibc and GC deletes the old one, every
  # rust binary dies with ENOENT. Reinstall stable whenever glibc changes
  # (also covers first activation on a fresh machine). Needs network; if
  # offline it warns and retries on the next activation.
  home.activation.rustupToolchain = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    stamp="$HOME/.rustup/.nix-glibc-stamp"
    if [ -z "''${DRY_RUN:-}" ] && [ "$(cat "$stamp" 2>/dev/null)" != "${pkgs.glibc}" ]; then
      ${pkgs.rustup}/bin/rustup toolchain uninstall stable >/dev/null 2>&1 || true
      if ${pkgs.rustup}/bin/rustup toolchain install stable; then
        ${pkgs.rustup}/bin/rustup default stable
        printf '%s' "${pkgs.glibc}" > "$stamp"
      else
        echo "rustup: toolchain install failed (offline?); rust stays broken until the next successful activation" >&2
      fi
    fi
  '';
}
