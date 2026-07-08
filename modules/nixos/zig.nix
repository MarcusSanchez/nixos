# Zig toolchain pinned to 0.16.0, with ZLS built against that exact compiler
# so editor tooling always matches the compiler version.
{ inputs, pkgs, ... }:

let
  zig = inputs.zig-overlay.packages.${pkgs.system}."0.16.0";
  zls = inputs.zls-overlay.packages.${pkgs.system}.zls.overrideAttrs (_: {
    nativeBuildInputs = [ zig ];
  });
in
{
  environment.systemPackages = [
    zig
    zls
  ];
}
