{ pkgs, ... }:
{
  home.stateVersion = "24.11";
  home.shellAliases = {
    ls = "ls --color -F";
    dr = "direnv allow";
    ta = "tmux attach";
    vi = "nvim";
    nix-run-build = "nix run .#build";
  };
  home.packages = with pkgs; [
    gemini-cli
    claude-code
  ];

  xdg.configFile = {
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

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;
    };
  };

  programs = {
    gpg.enable = true;
    ripgrep.enable = true;
    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-copilot
        gh-notify
        gh-dash
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
        "--prompt=\ "
        "--pointer=\ "
      ];
    };

    lazygit = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    tmux = import ./tmux.nix {
      inherit pkgs;
    };
    git = import ./git;
    zsh = import ./zsh.nix {
      inherit pkgs;
    };
    neovim = import ./nvim {
      inherit pkgs;
    };
  };
}
