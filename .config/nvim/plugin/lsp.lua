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
-- lspconfig's defaults list filetypes nvim never detects; :checkhealth warns on each
local unknown_fts = {
  'c.doxygen', 'cpp.doxygen', 'markdown.mdx', 'aspnetcorerazor', 'astro-markdown',
  'django-html', 'edge', 'ejs', 'erb', 'gohtml', 'gohtmltmpl', 'hbs', 'html-eex',
  'jade', 'leaf', 'mdx', 'njk', 'nunjucks', 'slim', 'postcss', 'sugarss', 'reason',
}
for _, name in ipairs({ 'clangd', 'marksman', 'tailwindcss' }) do
  vim.lsp.config(name, {
    filetypes = vim.tbl_filter(function(ft)
      return not vim.list_contains(unknown_fts, ft)
    end, vim.lsp.config[name].filetypes),
  })
end
-- also treat Eclipse projects (.project) as roots; otherwise jdtls only reports syntax errors
local jdtls_markers = vim.lsp.config.jdtls.root_markers
vim.lsp.config('jdtls', {
  root_markers = { jdtls_markers[1], vim.list_extend({ '.project' }, jdtls_markers[2]) },
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
