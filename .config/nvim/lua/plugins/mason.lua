return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "ast_grep",
            "basedpyright",
            "bashls",
            "clangd",
            "eslint",
            "lua_ls",
            "marksman",
            "ruff",
            "rust_analyzer",
            "tailwindcss",
            "ts_ls",
        },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
