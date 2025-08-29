return {
  cmd = { 'nix', 'shell', 'nixpkgs#vscode-langservers-extracted', '-c', 'vscode-css-language-server', '--stdio', },
  filetypes = { 'css' },
}
