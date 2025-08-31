return {
  cmd = { 'nix', 'shell', 'nixpkgs#vscode-langservers-extracted', '-c', 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
}
