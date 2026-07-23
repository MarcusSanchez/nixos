# Linux-only packages: build essentials the mac gets from Xcode CLT and
# macOS itself (clang, make, bsdtar, curl). Everything shared lives in
# modules/common/packages.nix.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    curl
    unzip
    gzip
    gnutar
  ];
}
