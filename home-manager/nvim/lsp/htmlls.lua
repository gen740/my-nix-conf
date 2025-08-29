return {
  cmd = { 'nix', 'shell', 'nixpkgs#vscode-langservers-extracted', '-c', 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
  settings = {
    html = {
      format = {
        templating = true,
        wrapLineLength = 120,
        wrapAttributes = 'auto',
        indentHandlebars = true,
        indentInnerHtml = true,
        preserveNewLines = true,
        maxPreserveNewLines = 2,
        indentEmptyLines = false,
        wrapAttributesIndentSize = 2
      }
    }
  }
}
