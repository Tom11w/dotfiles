require("catppuccin").setup({
    term_colors = true,

    native_lsp = {
        enabled = true,
        virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
        },
        underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
        },
        inlay_hints = {
            background = true,
        },
    },
})

require('colorizer').setup{
    filetypes = { "*" },
    user_default_options = {
      tailwind = true, -- Enable tailwind colors
      css = true,
      always_update = true,
    }
  }
vim.cmd.colorscheme "catppuccin"
