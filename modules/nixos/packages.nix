# System-wide development toolchains and CLI basics.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    curl
    unzip
    gzip
    gnutar
    tree

    nodejs_latest

    go
    gopls

    rustup # all you need for rust development

    # zls is built against this same nixpkgs zig, so the compiler and
    # language server stay on matching versions automatically
    zig
    zls
  ];
}
