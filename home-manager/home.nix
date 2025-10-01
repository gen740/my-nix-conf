{ pkgs, ... }:
let
  callModule = module: import module { inherit pkgs; };
  neovimNightly = pkgs.neovim-unwrapped.overrideAttrs (_: {
    version = "v0.12.0-dev";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "6d550f3cdbca6091042526a0153e0db18192447e";
      sha256 = "sha256-fexPHQXI78SnB0bhiV1CgagLjNQsQk++LLb2NdEQLfI=";
    };
    treesitter-parsers = import ./treesitter-parsers.nix { fetchurl = pkgs.fetchurl; };
  });
in
{
  home = {
    stateVersion = "25.11";
    shellAliases = {
      ls = "${pkgs.coreutils}/bin/ls --color=auto -F";
      vi = "nvim";
    };
    packages = with pkgs; [
      gemini-cli
      claude-code
      codex
      neovimNightly
      container
    ];
  };

  xdg = {
    enable = true;
    configFile = {
      "git/git-commitmessage.txt" = {
        source = ./git/git-commitmessage.txt;
      };
      "nvim" = {
        source = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "my-nvim-config";
          version = "1.0";
          src = ./nvim;
          dontBuild = true;
          lsps = pkgs.replaceVars ./nvim/lua/lsps.lua {
            biome = "${pkgs.biome}/bin/biome";
            clangd = "${pkgs.clang-tools}/bin/clangd";
            cmake = "${pkgs.cmake-language-server}/bin/cmake-language-server";
            copilot = "${pkgs.copilot-language-server}/bin/copilot-language-server";
            cssls = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
            htmlls = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
            jsonls = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
            lua_ls = "${pkgs.lua-language-server}/bin/lua-language-server";
            nixd = "${pkgs.nixd}/bin/nixd";
            pyright = "${pkgs.pyright}/bin/pyright";
            ruff = "${pkgs.ruff}/bin/ruff";
            vtsls = "${pkgs.vtsls}/bin/vtsls";
            yamlls = "${pkgs.yaml-language-server}/bin/yaml-language-server";
          };
          installPhase = ''
            mkdir -p $out
            cp -R $src/* $out
            chmod -R +w $out
            cp -f ${lsps} $out/lua/lsps.lua
          '';
        };
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
