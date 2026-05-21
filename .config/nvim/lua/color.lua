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
  auto_integrations = true,
})

require('colorizer').setup({
  user_default_options = {
    tailwind = true, -- Enable tailwind colors
    css = true,
    always_update = true,
    xterm = true, -- Enable xterm 256-color codes (#xNN, \e[38;5;NNNm)
  }
})
vim.cmd.colorscheme "catppuccin-nvim"
