return {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "ast_grep",
            "bashls",
            "clangd",
            "eslint",
            "lua_ls",
            "python-lsp-server",
            "ruff",
            "rust-analyzer",
            "tailwindcss",
            "ts_ls",
        }
    }
}
