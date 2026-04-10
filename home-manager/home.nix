{ pkgs, ... }:
let
  callModule = module: import module { inherit pkgs; };
  neovimNightly = (
    pkgs.neovim-unwrapped.overrideAttrs (old: {
      treesitter-parsers =
        old.treesitter-parsers
        // (with pkgs.tree-sitter.builtGrammars; {
          bash = tree-sitter-bash;
          cmake = tree-sitter-cmake;
          cpp = tree-sitter-cpp;
          csv = tree-sitter-csv // {
            location = "csv";
          };
          css = tree-sitter-css;
          diff = tree-sitter-diff;
          dockerfile = tree-sitter-dockerfile;
          dot = tree-sitter-dot;
          gitcommit = tree-sitter-gitcommit;
          git_config = tree-sitter-git-config;
          git_rebase = tree-sitter-git-rebase;
          go = tree-sitter-go;
          html = tree-sitter-html;
          javascript = tree-sitter-javascript;
          json = tree-sitter-json;
          nix = tree-sitter-nix;
          proto = tree-sitter-proto;
          python = tree-sitter-python;
          ruby = tree-sitter-ruby;
          rust = tree-sitter-rust;
          toml = tree-sitter-toml;
          tsx = tree-sitter-tsx // {
            language = "typescriptreact";
          };
          typescript = tree-sitter-typescript;
          typst = tree-sitter-typst;
          vhdl = tree-sitter-vhdl;
          yaml = tree-sitter-yaml;
        });
    })
  );
in
{
  home = {
    stateVersion = "26.05";
    shellAliases = {
      ls = "${pkgs.coreutils}/bin/ls --color=auto -F";
      vi = "nvim";
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
    };
    packages = with pkgs; [
      gemini-cli
      claude-code
      copilot-cli
      codex
      neovimNightly

      git
      wget
      curl

      libarchive
      gzip
      bzip2
      xz
      gnutar
      zstd

      comma
      kitty
    ];
  };

  xdg = {
    enable = true;
    configFile = {
      "git/hooks/prepare-commit-msg" = {
        source = ./git/hooks/prepare-commit-msg;
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
            pyright = "${pkgs.basedpyright}/bin/basedpyright-langserver";
            ruff = "${pkgs.ruff}/bin/ruff";
            vtsls = "${pkgs.vtsls}/bin/vtsls";
            yamlls = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            vhdlls = "${pkgs.vhdl-ls}/bin/vhdl_ls";
            texlab = "${pkgs.texlab}/bin/texlab";
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
    pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry;
  };

  programs = {
    gpg = {
      enable = true;
    };
    gh = {
      enable = true;
      extensions = with pkgs; [
        github-copilot-cli
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
