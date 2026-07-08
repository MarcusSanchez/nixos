# Catppuccin theming across CLI tools. nvim is themed by LazyVim itself.
{ inputs, ... }:

{
  imports = [ inputs.catppuccin.homeModules.default ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";

    zsh-syntax-highlighting.enable = true;
    atuin.enable = true;
    nvim.enable = false;
  };
}
