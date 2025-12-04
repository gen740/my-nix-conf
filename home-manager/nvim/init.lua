--------------------------------------------------------------------------------
--- Basic Settings
--------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.list = true
vim.opt.listchars = { tab = '»·', trail = '·', extends = '›', precedes = '‹' }
vim.opt.pumheight = 15
vim.opt.completeopt = { 'fuzzy', 'menu', 'menuone', 'noselect', 'popup' }
vim.opt.wildignore:append { "*/build/*", "*/.git/*", "*/venv/*", "*/wokdir/*" }

if vim.fn.executable("pbcopy") == 1 then
  vim.g.clipboard = "pbcopy"
elseif os.getenv('SSH_TTY') then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

vim.g.netrw_banner = 0
vim.g.netrw_hide = 1
vim.g.netrw_keepj = "keepj"
vim.g.netrw_list_hide = [[\(^\.\/\=$\)\|\(^\.\.\/\=$\)\|\(^\.DS_Store$\)]]
vim.g.netrw_sort_sequence = [[^[^\.].*\/$,^\..*\/$,^[^\.][^\/]*$,^\.[^\/]*$]]

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_gzip = 0
vim.g.loaded_zip = 0
vim.g.loaded_zipPlugin = 0
vim.g.loaded_tutor_mode_plugin = 0
vim.g.loaded_tarPlugin = 0
vim.g.loaded_remote_plugins = 0

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
  end,
})

--------------------------------------------------------------------------------
--- Keymaps
--------------------------------------------------------------------------------
for mode, keys in pairs {
  i = {
    ['<m-n>'] = function()
      vim.lsp.inline_completion.select({})
    end,
    ['<m-p>'] = function()
      vim.lsp.inline_completion.select({ count = -1 })
    end,
    ['<c-t>'] = function()
      if not vim.lsp.inline_completion.get() then
        return "<c-t>"
      end
    end,
  },
  n = {
    ['-'] = "<cmd>execute 'Explore ' . fnameescape(fnamemodify(expand('%:p'), ':h'))<cr>",
    ['<m-f>'] = function()
      vim.lsp.buf.format {
        async = false,
        filter = function(client)
          return (
            client.name ~= 'vtsls'
            and client.name ~= 'texlab'
          )
        end,
      }
    end,

    ['<space>e'] = vim.diagnostic.open_float,
    ['[d'] = function() vim.diagnostic.jump { count = -1, float = true } end,
    [']d'] = function() vim.diagnostic.jump { count = 1, float = true } end,
    ['<space>lc'] = vim.diagnostic.setloclist,
    ['<space>lo'] = vim.lsp.buf.outgoing_calls,
    ['<space>li'] = vim.lsp.buf.incoming_calls,
    ['gD'] = vim.lsp.buf.declaration,
    ['gd'] = vim.lsp.buf.definition,
    ['gr'] = vim.lsp.buf.references,
    ['K'] = vim.lsp.buf.hover,
    ['gi'] = vim.lsp.buf.implementation,
    ['<C-k>'] = vim.lsp.buf.signature_help,
    ['<space>D'] = vim.lsp.buf.type_definition,
    ['<space>rn'] = vim.lsp.buf.rename,
    ['<space>ca'] = function() vim.lsp.buf.code_action { apply = true } end,
  },
  t = {
    ['<esc>'] = '<C-\\><C-n>',
    ['<esc><esc>'] = '<esc>',
  },
} do
  for key, callback in pairs(keys) do
    if type(callback) == 'table' then
      vim.keymap.set(mode, key, callback[1], callback[2])
    else
      vim.keymap.set(mode, key, callback, { noremap = true, silent = true })
    end
  end
end

--------------------------------------------------------------------------------
--- LSP Settings
--------------------------------------------------------------------------------
vim.lsp.config('*', {
  on_attach = function(client, bufnr)
    if client:supports_method('textDocument/completion') then
      if client.server_capabilities.completionProvider ~= nil then
        local chars = {}
        for i = 32, 126 do
          table.insert(chars, string.char(i))
        end
        client.server_capabilities.completionProvider.triggerCharacters = chars
      end
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
          return { abbr = item.label:gsub('%b()', '') }
        end,
      })
    end
  end,
})
vim.lsp.enable {
  'nixd',
  'lua_ls',
  'jsonls',
  'yamlls',
  'clangd',
  'pyright',
  'ruff',
  'cmake',
  'copilot',
  'vtsls',
  'biome',
  'cssls',
  'htmlls',
  -- 'vhdlls',
}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'copilot' then
      vim.lsp.inline_completion.enable()
    end
    if client.name == 'nixd' then
      vim.lsp.inlay_hint.enable()
    end
  end,
})

vim.api.nvim_create_user_command('CopilotSignIn', function()
  local copilot_client = vim.lsp.get_clients({ name = "copilot" })[1]
  if copilot_client == nil then
    print("Copilot LSP client is not available for this buffer.")
    return
  end
  --- @diagnostic disable-next-line: param-type-mismatch
  vim.print(copilot_client.request_sync("signIn", vim.empty_dict(), 1000, 0))
end, {})

vim.api.nvim_create_user_command("NixBuild", function(opts)
  local target = opts.args ~= "" and opts.args or "build"
  local cmd = { "nix", "run", ".#" .. target, "-L" }

  vim.fn.setqflist({}, "r")
  vim.fn.setqflist({}, "a", { title = "NixBuild: " .. target })

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            vim.fn.setqflist({}, "a", { lines = { line } })
          end
        end
      end
    end,

    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            vim.fn.setqflist({}, "a", { lines = { line } })
          end
        end
      end
    end,

    on_exit = function()
      vim.cmd("copen")
    end,
  })
end, {
  nargs = "?",
})

--------------------------------------------------------------------------------
--- ColorScheme
--------------------------------------------------------------------------------
vim.cmd.colorscheme "retrobox"
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
