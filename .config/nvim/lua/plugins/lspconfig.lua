return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("mason").setup({
        ensure_installed = {
            "ts_ls",
            "tailwindcss",
            "eslint-lsp",
            "lua-language-server",
            "javascript",
            "tsx",
            "prettierd",
            "python-lsp-server",
        }
            })
        require("mason-lspconfig").setup()
        --require "config.lspconfig"
    end,
}
