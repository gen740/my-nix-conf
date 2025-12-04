local function skim_forward_sync()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local texfile = vim.fn.expand("%:p")
  local pdffile = vim.fn.getcwd() .. "/main.pdf"

  local cmd = string.format(
    '$(nix path-info nixpkgs\\#skimpdf)/Applications/Skim.app/Contents/SharedSupport/displayline ' ..
    '-r -b %d %q %q',
    line, pdffile, texfile
  )

  vim.fn.jobstart({ "sh", "-c", cmd }, { detach = true })
end

vim.keymap.set("n", "<CR><CR>", skim_forward_sync, { noremap = true, silent = true })
