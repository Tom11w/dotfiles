vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
})

-- fzf-native is a C extension that needs compiling once (lazy's `build = 'make'`)
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('my.telescope', {}),
  callback = function(ev)
    if ev.data.spec.name == 'telescope-fzf-native.nvim'
        and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
  end,
})

require('telescope').setup {
  pickers = {
    find_files = {
      theme = "ivy"
    }
  },
  extensions = {
    fzf = {}
  }
}

require('telescope').load_extension('fzf')

vim.keymap.set("n", "<space>th", require('telescope.builtin').help_tags)
vim.keymap.set("n", "<space>td", require('telescope.builtin').find_files)
vim.keymap.set("n", "<space>tn", function()
  require('telescope.builtin').find_files {
    cwd = vim.fn.stdpath("config")
  }
end)

require('config.telescope.multigrep').setup()
