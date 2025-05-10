return {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "ts_ls",
            "tailwindcss",
            "eslint",
            "lua_ls",
            "ast_grep",
            "clangd",
            "python-lsp-server",
            "ruff",
            "bashls",
        }
    }
}
