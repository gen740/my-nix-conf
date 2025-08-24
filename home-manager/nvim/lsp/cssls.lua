return {
  cmd = {
    'nix',
    'run',
    'nixpkgs#vscode-css-languageserver',
    '--',
    '--stdio',
  },
  filetypes = { 'css' },
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
  end,
}
