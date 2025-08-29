{ pkgs, ... }:
{
  enable = true;
  withNodeJs = true;
  # plugins = with pkgs.vimPlugins; [
  #   github-nvim-theme
  #   (nvim-treesitter.withAllGrammars.overrideAttrs (old: {
  #     version = "v0.10.0";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "nvim-treesitter";
  #       repo = "nvim-treesitter";
  #       rev = "v0.10.0";
  #       sha256 = "sha256-CVs9FTdg3oKtRjz2YqwkMr0W5qYLGfVyxyhE3qnGYbI=";
  #     };
  #   }))
  # ];
  package = pkgs.neovim-unwrapped.overrideAttrs (old: {
    version = "v0.12.0-dev";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "c10e36fc016cb265026a772571ce0a405df2ab71";
      sha256 = "sha256-lmUo3im/tnY92LTqufr5Xbd8eWfAkiCAbf6Kx9IKu+0=";
    };
  });
}
