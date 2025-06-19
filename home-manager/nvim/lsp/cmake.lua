return {
  cmd = {
    'nix', 'run', 'nixpkgs#cmake-language-server',
  },
  filetypes = { 'cmake' },
  init_options = {
    buildDirectory = 'build',
  },
  single_file_support = true,
  on_attach = function(client, bufnr)
    local chars = {}
    for i = 32, 126 do
      table.insert(chars, string.char(i))
    end
    client.server_capabilities.completionProvider.triggerCharacters = chars
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub('%b()', '') }
      end,
    })
  end,
}
