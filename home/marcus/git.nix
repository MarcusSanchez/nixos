# Git identity and GitHub CLI (gh also acts as the git credential helper).
{ ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Marcus Sanchez";
      email = "marcussanchez031@gmail.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
