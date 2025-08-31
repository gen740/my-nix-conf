{ pkgs, ... }:
let
  callModule = module: import module { inherit pkgs; };

  neovimNightly = (
    pkgs.neovim-unwrapped.overrideAttrs (old: {
      version = "v0.12.0-dev";
      src = pkgs.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "c333d64663d3b6e0dd9aa440e433d346af4a3d81";
        sha256 = "sha256-e4f/hLMYDAfLipKwcrqxw7aJtB/2PePF2ddWWyP730Q=";
      };
      treesitter-parsers = rec {
        c.src = pkgs.fetchurl {
          url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.24.1.tar.gz";
          hash = "sha256-Jd1Ls97HcHaaQH4PyAP0JM4CxJSlbOlf7cUlMW3Pm0g=";
        };
        cpp.src = pkgs.fetchurl {
          url = "https://github.com/tree-sitter/tree-sitter-cpp/archive/v0.23.4.tar.gz";
          hash = "sha256-tmxQQ+JthOXxegWa9xsVe88gIiEGntIgqhaW19HSino=";
        };
        lua.src = pkgs.fetchurl {
          url = "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/v0.4.0.tar.gz";
          hash = "sha256-sJd6ztSmO7dfJnJXh+BHuPX0oJJxLIQOpwcHZdQElVk=";
        };
        vim.src = pkgs.fetchurl {
          url = "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/v0.7.0.tar.gz";
          hash = "sha256-ROq8MRJ8T+rNoZ8qBaV4gnISj/VhzgEJOot6U6rcx7I=";
        };
        vimdoc.src = pkgs.fetchurl {
          url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v4.0.0.tar.gz";
          hash = "sha256-gJZ5TA8JCy10t7/5RUisG+MoW5Kex0+Dm9mz/09Mags=";
        };
        query.src = pkgs.fetchurl {
          url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.6.2.tar.gz";
          hash = "sha256-kGguEo0Ej78qKhftypR9tx4yb6Cz26QTbgQeCWU4tOs=";
        };
        markdown = {
          src = pkgs.fetchurl {
            url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.5.0.tar.gz";
            hash = "sha256-FMLJSMzw6bYG7sObCShsWd3fKDB4SfcbfOKx0e8Gk34=";
          };
          location = "tree-sitter-markdown";
        };
        markdown_inline = {
          src = markdown.src;
          location = "tree-sitter-markdown-inline";
          language = "markdown_inline";
        };
      };
    })
  );

in
{
  home = {
    stateVersion = "25.11";
    shellAliases = {
      ls = "ls --color -F";
      dr = "direnv allow";
      ta = "tmux attach";
      vi = "nvim";
      nix-run-build = "nix run .#build";
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
    ripgrep.enable = true;
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
      nix-direnv.enable = true;
    };
    tmux = callModule ./tmux.nix;
    git = callModule ./git;
    zsh = callModule ./zsh.nix;
  };
}
