return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "ast-grep",
      "bash-language-server",
      "clangd",
      "eslint-lsp",
      "eslint_d",
      "lua_ls",
      "marksman",
      "ruff",
      "rust_analyzer",
      "tailwindcss-language-server",
      "typescript-language-server",
    },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
