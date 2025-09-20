return {
  cmd = { require("lsps").htmlls, '--stdio' },
  filetypes = { 'html' },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
}
