return {
  cmd = {
    'nix',
    'shell',
    'nixpkgs#vscode-langservers-extracted',
    '-c',
    'vscode-css-language-server',
    '--stdio',
  },
  filetypes = { 'css' },
  -- settings = {
  --   css = {
  --     validate = true,
  --     lint = {
  --       unknownAtRules = "ignore",
  --       unknownProperties = "ignore",
  --       validProperties = {},
  --     },
  --     completion = {
  --       completePropertyWithSemicolon = true,
  --       triggerPropertyValueCompletion = true
  --     }
  --   },
  --   scss = {
  --     validate = true,
  --     lint = {
  --       unknownAtRules = "ignore",
  --       unknownProperties = "ignore"
  --     }
  --   },
  --   less = {
  --     validate = true,
  --     lint = {
  --       unknownAtRules = "ignore",
  --       unknownProperties = "ignore"
  --     }
  --   }
  -- },
  -- on_attach = function(client, _)
  --   client.server_capabilities.document_formatting = false
  -- end,
}
