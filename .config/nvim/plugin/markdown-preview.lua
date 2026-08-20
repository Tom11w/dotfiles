vim.g.mkdp_filetypes = { 'markdown' }

vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })

-- markdown-preview ships a node app that needs building once
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('my.mkdp', {}),
  callback = function(ev)
    if ev.data.spec.name == 'markdown-preview.nvim'
        and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.system({ 'yarn', 'install' }, { cwd = ev.data.path .. '/app' })
    end
  end,
})

vim.keymap.set('n', '<space>p', '<cmd>MarkdownPreviewToggle<CR>',
  { noremap = true, silent = true, desc = 'Markdown preview toggle' })
