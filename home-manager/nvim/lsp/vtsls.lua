return {
  cmd = {
    'nix',
    'run',
    'nixpkgs#vtsls',
    '--',
    '--stdio',
  },
  filetypes = { 'typescript' },
}
