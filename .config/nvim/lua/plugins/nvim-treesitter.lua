return {
  "nvim-treesitter/nvim-treesitter",
  config = function ()
    require("nvim-treesitter.configs").setup {
      refactor = {
        highlight_definitions = {
          enable = true,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = false,
        },
        smart_rename = {
          enable = true,
          -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
          keymaps = {
            smart_rename = " r",
          },
        },
        highlight_current_scope = { enable = false},
      },
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "css",
        "c",
        "python",
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
    }
  end,
  build = ":TSUpdate",
}
