{ pkgs, ... }:
{
  enable = true;
  package = pkgs.neovim-unwrapped.overrideAttrs (old: {
    version = "v0.12.0-dev";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "772f1966a348eb26bc9cb17d45bbdb739642ccdb";
      sha256 = "sha256-6BpBzWhhxRS+MDWqPyDYDZFQc8qJc7HcgS2iudA3c3s=";
    };
  });
}
