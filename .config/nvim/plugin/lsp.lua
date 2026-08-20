vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/folke/lazydev.nvim',
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',
    'lua_ls',
    'marksman',
    'ruff',
    'rust_analyzer',
  },
})

require('lazydev').setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})

local capabilities = require('blink.cmp').get_lsp_capabilities({
  general = {
    positionEncodings = { 'utf-16' },
  },
})
vim.lsp.config('*', { capabilities = capabilities })
-- --clang-tidy turns on the checks (incl. clang-analyzer-* = Xcode's "Analyze")
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--clang-tidy', '--background-index', '--header-insertion=never' },
})
vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ruff')
vim.lsp.enable('ty')

vim.diagnostic.config({
  float = {
    source = true,
    border = 'rounded',
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Highlight other references to the symbol under the cursor (replaces the
    -- old nvim-treesitter-refactor highlight_definitions; LSP-accurate now).
    if client:supports_method('textDocument/documentHighlight') then
      local hl = vim.api.nvim_create_augroup('my.lsp.highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = hl, buffer = args.buf, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = hl, buffer = args.buf, callback = vim.lsp.buf.clear_references,
      })
    end

    -- Auto-format on save (unless server handles it via willSaveWaitUntil).
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
