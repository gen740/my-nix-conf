{ pkgs, ... }:
let
  callModule = module: import module { inherit pkgs; };
  neovimNightly = (
    pkgs.neovim-unwrapped.overrideAttrs (old: {
      version = "v0.12.0-dev";
      src = pkgs.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "c6bfc203f10f325fa6d09d3624fc01e91697bd67";
        sha256 = "sha256-mD21vueymbeGCo2jMNeU9n6Df3OQPqeAEHxnKpxI+RU=";
      };
      treesitter-parsers = import ./treesitter-parsers.nix { fetchurl = pkgs.fetchurl; };
    })
  );
in
{
  home = {
    stateVersion = "25.11";
    shellAliases = {
      lsc = "ls --color -F";
      vi = "nvim";
    };
    packages = with pkgs; [
      gemini-cli
      claude-code
      neovimNightly
    ];
  };

  xdg = {
    enable = true;
    configFile = {
      "git/git-commitmessage.txt" = {
        source = ./git/git-commitmessage.txt;
      };
      "nvim" = {
        source = ./nvim;
      };
      "ghostty" = {
        source = ./ghostty;
      };
    };
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;
  };

  programs = {
    gpg.enable = true;
    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-copilot
      ];
      settings = {
        git_protocol = "ssh";
        editor = "nvim";
        prompt = "enabled";
      };
    };
    fd = {
      enable = true;
      ignores = [
        ".git"
        "node_modules"
        ".cache"
        ".direnv"
        ".DS_Store"
      ];
    };
    ripgrep.enable = true;
    fzf = {
      enable = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--border=none"
        "--height=24"
        "--scroll-off=3"
        "--no-mouse"
        "--prompt=\\ "
        "--pointer=\\ "
      ];
    };
    lazygit.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    tmux = callModule ./tmux.nix;
    git = callModule ./git;
    zsh = callModule ./zsh.nix;
  };
}
