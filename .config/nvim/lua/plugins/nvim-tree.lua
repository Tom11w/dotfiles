local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- OR use all default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- add your mappings
  vim.keymap.set("n", "?",     api.tree.toggle_help,                  opts("Help"))
  vim.keymap.set("n", "l",     api.node.open.edit,                  opts("Open"))
  vim.keymap.set("n", "h",     api.node.navigate.parent_close,      opts("Close"))
  ---
end

return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {
          on_attach = my_on_attach,
            renderer = {
                highlight_opened_files = "none",
                highlight_modified = "all",
            },
            diagnostics = {
              enable = true,
              show_on_dirs = false,
              show_on_open_dirs = true,
              debounce_delay = 50,
              severity = {
                min = vim.diagnostic.severity.HINT,
                max = vim.diagnostic.severity.ERROR,
              },
              icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
              },
            },
            modified = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = false,
            },
            update_focused_file = {
                enable = true,
                update_root = {
                    enable = false,
                    ignore_list = {},
                },
                exclude = false,
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                }
            },
            view = {
              adaptive_size = true,
            }
        }
    end,
}
