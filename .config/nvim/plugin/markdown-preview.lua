vim.g.mkdp_filetypes = { 'markdown' }

vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })

-- install.sh fetches a prebuilt server with node built in
local app = vim.pack.get({ 'markdown-preview.nvim' }, { info = false })[1].path .. '/app'
if vim.fn.glob(app .. '/bin/markdown-preview-*') == '' then
  vim.system({ './install.sh' }, { cwd = app }, function(r)
    if r.code ~= 0 then
      vim.schedule(function()
        vim.notify('markdown-preview: install.sh failed\n' .. r.stderr, vim.log.levels.WARN)
      end)
    end
  end)
end

vim.keymap.set('n', '<space>p', '<cmd>MarkdownPreviewToggle<CR>',
  { silent = true, desc = 'Markdown preview toggle' })
