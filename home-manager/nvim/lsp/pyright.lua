return {
  cmd = {
    'nix',
    'shell',
    'nixpkgs#pyright',
    '-c',
    'pyright-langserver',
    '--stdio'
  },
  filetypes = { 'python' },
}
