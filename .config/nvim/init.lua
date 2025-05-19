-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


local map = vim.api.nvim_set_keymap
vim.g.mapleader = ' '

require("config.lazy")

require('nvim-tmux-navigation')


-- General settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.spelllang = "en"

-- Line numbering
vim.opt.number = true         -- Equivalent to `set nu`
vim.opt.relativenumber = true -- Equivalent to `set relativenumber`

-- Highlight the 80th column
vim.opt.colorcolumn = "80" -- Equivalent to `set colorcolumn=80`

-- Highlight the current line
vim.opt.cursorline = true -- Equivalent to `set cul`


vim.opt.scrolloff  = 5

-- always show signcolumns
vim.opt.signcolumn = 'yes'

vim.opt.hidden     = true
-- " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.


vim.opt.updatetime = 50

vim.opt.isfname:append("@-@")



---- Airline settings
vim.g.airline_theme = 'catppuccin'
vim.g.airline_powerline_fonts = 1


require('colortest')

-- Set Python paths
vim.g.python3_host_prog = '~/Envs/vimpy3env/bin/python'
-- vim.g.python_host_prog = '/Users/tom11w/Envs/vimpy2env/bin/python'

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- require('dapui').setup()
-- require('dap-python').setup('~/Envs/vimpy3env/bin/python')
--
-- vim.api.nvim_set_keymap("n", "<space>dt", ":lua require'dapui'.toggle()<CR>", {noremap=true})
-- vim.api.nvim_set_keymap("n", "<space>db", ":lua require'dap'.toggle_breakpoint()<CR>", {noremap=true})
-- vim.api.nvim_set_keymap("n", "<space>dc", ":lua require'dap'.continue()<CR>", {noremap=true})
-- vim.api.nvim_set_keymap("n", "<space>dr", ":lua require('dapui').open({reset = true})<CR>", {noremap=true})


-- goto definition and goto declaration
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- open/clase tree
map('n', '<space>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- tmux navigation keys
map('n', '<c-w>h', '<Cmd>NvimTmuxNavigateLeft<CR>', { noremap = true, silent = true })
map('n', '<c-w>j', '<Cmd>NvimTmuxNavigateDown<CR>', { noremap = true, silent = true })
map('n', '<c-w>k', '<Cmd>NvimTmuxNavigateUp<CR>', { noremap = true, silent = true })
map('n', '<c-w>l', '<Cmd>NvimTmuxNavigateRight<CR>', { noremap = true, silent = true })
map('n', '<C-w>\\', '<Cmd>NvimTmuxNavigateLastActive<CR>', { noremap = true, silent = true })
map('n', '<C-Space>', '<Cmd>NvimTmuxNavigateNext<CR>', { noremap = true, silent = true })


require("ibl").setup {
    indent = {
        char = {
            "|", "¦", "┆", "┊"
        },
    },
    scope = { enabled = false },
}

-- Show special characters
vim.opt.list = true
vim.opt.listchars = {
    eol = "⏎",
    tab = "|-▶",
    trail = "~",
    extends = ">",
    precedes = "<",
    nbsp = "␣"
}

--  space = "·",
