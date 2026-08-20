vim.pack.add({
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1') },
  'https://github.com/rafamadriz/friendly-snippets',
})

require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  signature = { enabled = true },
  completion = {
    menu = { border = 'rounded' },
    documentation = {
      auto_show = true,
      window = { border = 'rounded' },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
