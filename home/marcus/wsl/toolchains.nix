# Real-directory toolchain copies for Windows-side IDEs, plus rustup repair.
#
# JetBrains on Windows browses WSL files over \\wsl$, which exposes Linux
# symlinks as reparse points its file picker can't traverse. Toolchains the
# IDE needs as a *directory* (GOROOT) must therefore be real dereferenced
# copies, not links into /nix/store. Plain executables (node, buf, ...)
# work fine straight from /run/current-system/sw/bin, and rustup's
# toolchains are already real directories, so RustRover works against
# ~/.rustup as-is.
{ pkgs, lib, ... }:

let
  ideToolchains = {
    go = "${pkgs.go}/share/go"; # GOROOT
  };
in
{
  home.activation.ideToolchains = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    sync_toolchain() {
      local name="$1" src="$2"
      local dir="$HOME/.toolchains/$name" stamp="$HOME/.toolchains/.$name-stamp"
      [ "$(cat "$stamp" 2>/dev/null)" = "$src" ] && return 0
      run rm -rf "$dir.new"
      # -L is the point: the copy must contain no symlinks at all, or the
      # Windows-side file picker breaks on them
      run cp -rL "$src" "$dir.new"
      run chmod -R u+w "$dir.new"
      run rm -rf "$dir"
      run mv "$dir.new" "$dir"
      run sh -c "printf '%s' '$src' > '$stamp'"
    }
    run mkdir -p "$HOME/.toolchains"
    ${lib.concatStrings (
      lib.mapAttrsToList (name: src: ''
        sync_toolchain ${name} ${src}
      '') ideToolchains
    )}
  '';

  # rustup-downloaded toolchains are patched against one specific store
  # glibc; when an upgrade bumps glibc and GC deletes the old one, every
  # rust binary dies with ENOENT. Reinstall stable whenever glibc changes
  # (also covers first activation on a fresh machine). Needs network; if
  # offline it warns and retries on the next activation.
  home.activation.rustupToolchain = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    stamp="$HOME/.rustup/.nix-glibc-stamp"
    if [ "$(cat "$stamp" 2>/dev/null)" != "${pkgs.glibc}" ]; then
      run ${pkgs.rustup}/bin/rustup toolchain uninstall stable || true
      if run ${pkgs.rustup}/bin/rustup toolchain install stable; then
        run ${pkgs.rustup}/bin/rustup default stable
        run sh -c "printf '%s' '${pkgs.glibc}' > '$stamp'"
      else
        echo "rustup: toolchain install failed (offline?); rust stays broken until the next successful activation" >&2
      fi
    fi
  '';
}
