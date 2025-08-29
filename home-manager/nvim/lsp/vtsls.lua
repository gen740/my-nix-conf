return {
  cmd = {
    'nix',
    'run',
    'nixpkgs#vtsls',
    '--',
    '--stdio',
  },
  filetypes = {
    'typescript',
    'javascript',
    'html',
    'typescriptreact',
    'javascriptreact',
    'vue',
    'svelte'
  },
}
