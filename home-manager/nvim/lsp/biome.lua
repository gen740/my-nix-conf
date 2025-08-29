return {
  cmd = {
    'nix',
    'run',
    'nixpkgs#biome',
    '--',
    'lsp-proxy',
    '--stdio',
  },
  filetypes = {
    'typescript',
    'javascript',
    'html',
    'typescriptreact',
    'javascriptreact',
    'vue',
    'svelte'
  },
}
