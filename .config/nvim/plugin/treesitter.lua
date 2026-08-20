vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/windwp/nvim-ts-autotag',
})

local langs = {
  'c', 'css', 'javascript', 'lua', 'markdown', 'markdown_inline',
  'python', 'rust', 'tsx', 'typescript', 'vim', 'vimdoc',
}

require('nvim-treesitter').install(langs) -- idempotent; no-op if already built
require('nvim-ts-autotag').setup()

-- main branch doesn't auto-enable highlighting; start it per buffer
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('my.treesitter', {}),
  pattern = langs,
  callback = function() pcall(vim.treesitter.start) end,
})
