{ pkgs, ... }:
let
  callModule = module: import module { inherit pkgs; };
in
{
  home = {
    stateVersion = "24.11";
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
    tmux = callModule ./tmux.nix;
    git = callModule ./git;
    zsh = callModule ./zsh.nix;
    neovim = callModule ./nvim;
  };
}
