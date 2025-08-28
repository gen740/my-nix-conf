return {
  cmd = {
    "bash",
    "-c",
    "NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#copilot-language-server --impure -- --stdio"
  },
  filetypes = {
    'c',
    'cpp',
    'html',
    'typescript',
    'javascript',
    'lua',
    'python',
  },
  init_options = {
    editorInfo = { name = "Neovim", version = "v0.12.0-dev" },
    editorPluginInfo = { name = "nvim-lspconfig", version = "local" },
  },
}
