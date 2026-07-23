# Fresh-machine bootstrap: give rustup a default toolchain so `cargo` and
# `rustc` work immediately. Much simpler than the WSL counterpart
# (../wsl/toolchains.nix): no glibc patching on darwin, so toolchains
# survive upgrades. Needs network; if offline it warns and retries on the
# next activation.
{ pkgs, lib, ... }:

{
  home.activation.rustupToolchain = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.rustup}/bin/rustup show active-toolchain >/dev/null 2>&1; then
      if run ${pkgs.rustup}/bin/rustup toolchain install stable; then
        run ${pkgs.rustup}/bin/rustup default stable
      else
        echo "rustup: toolchain install failed (offline?); will retry on the next activation" >&2
      fi
    fi
  '';
}
