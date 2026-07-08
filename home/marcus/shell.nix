# Interactive shell: zsh + oh-my-zsh, plus the CLI helpers hooked into it.
{ lib, ... }:

{
  programs.zoxide.enable = true;
  programs.atuin.enable = true;

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
