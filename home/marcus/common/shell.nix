# Interactive shell: zsh + oh-my-zsh, plus the CLI helpers hooked into it.
{ config, lib, ... }:

{
  programs.zoxide.enable = true;
  programs.atuin.enable = true;

  # Auto-load per-project dev shells: a project with an .envrc saying
  # `use flake` gets its devShell on cd-in, dropped on cd-out.
  # nix-direnv caches the shell so re-entry is instant.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Let `npm install -g` work natively: install into a writable prefix
  # instead of the read-only nix store. Deliberately impure — global npm
  # CLIs are throwaway convenience tools here, and nix-ld covers any
  # native binaries they ship.
  home.sessionVariables.NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  home.sessionPath = [ "${config.home.homeDirectory}/.npm-global/bin" ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    autosuggestion.strategy = [
      "history"
      "completion"
    ];

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "last-working-dir"
      ];
    };

    # Ordered after tool integrations (zoxide/atuin, order 1000) so the
    # keybindings below always win, regardless of module import order.
    initContent = lib.mkOrder 1200 ''
      alias cls='clear'
      precmd() { echo }

      bindkey '^I' autosuggest-accept
      bindkey "$terminfo[kcbt]" expand-or-complete
    '';
  };
}
