return {
  cmd = { 'nix', 'run', 'nixpkgs#biome', '--', 'lsp-proxy', '--stdio', },
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' },
}
