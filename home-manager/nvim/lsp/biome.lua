return {
  cmd = { require("lsps").biome, 'lsp-proxy', '--stdio', },
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' },
}
