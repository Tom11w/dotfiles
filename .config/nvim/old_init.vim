set runtimepath^=~/.vim runtimepath+=~/.vim/after
source ~/.vimrc
let g:python3_host_prog = '/Users/tom11w/Envs/vimpy3env/bin/python'
let g:python_host_prog = '/Users/tom11w/Envs/vimpy2env/bin/python'
let &packpath = &runtimepath
call plug#begin()
"Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'Yggdroot/indentLine'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lambdalisue/battery.vim'
Plug 'vim-airline/vim-airline'
"Plug 'tomasiser/vim-code-dark'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'vim-airline/vim-airline-themes'
"Plug 'martinsione/darkplus.nvim'
"Plug 'vim-syntastic/syntastic'
Plug 'frazrepo/vim-rainbow'
Plug 'rust-lang/rust.vim'
Plug 'alexghergh/nvim-tmux-navigation'
"Plug 'sophacles/vim-processing'
"Plug 'mfussenegger/nvim-dap'
"Plug 'rcarriga/nvim-dap-ui'
"Plug 'mfussenegger/nvim-dap-python'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
"Plug 'nvim-neotest/nvim-nio'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
call plug#end()

lua require('nvim-tmux-navigation')


"lua require('dap-python').setup('~/Envs/vimpy3env/bin/python')
"lua require('dapui').setup()


":nmap <space>dt :lua require('dap').continue()<CR>
":nmap <space>db :lua require('dap').toggle_breakpoint()<CR>
":nmap <space>dc :lua require('dap').continue()<CR>
":nmap <space>dr :lua require('dapui').open({reset = true})<CR>


:nmap <space>e :CocCommand explorer --quit-on-open <CR>

:nmap <space>r :CocCommand document.renameCurrentWord <CR>

set tabstop=4
set shiftwidth=2
set expandtab
"colorscheme codedark
"colorscheme darkplus

let g:codedark_italics=1

let g:airline_theme = 'catppuccin'
let g:airline_powerline_fonts = 1
let g:airline#extensions#battery#enabled = 1
set spelllang=en
nnoremap <silent> <F8> :setlocal spell!<cr>
inoremap <silent> <F8> <C-O>:set spell!<cr>


let g:rainbow_active = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_c_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = 'cpplint'

"function! Tab_Or_Complete()
"  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
"    return "\<C-N>"
"  else
"    return "\<Tab>"
"  endif
"endfunction
":inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{ObsessionStatus()}
set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

set termguicolors
lua require('colortest')
"colorscheme catppuccin-mocha



" coc config -------
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-pyright',
  \ ]
" from readme
" if hidden is not set, TextEdit might fail.


set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300


" always show signcolumns
set signcolumn=yes



let g:ale_completion_enabled = 0
let g:ale_linters = {'python': ['flake8', 'pylint'], 'javascript': ['eslint']}

let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" remove this latter maybe
"

"setlocal isfname+=@-@
"setlocal includeexpr=substitute(v:fname,'^@\/','/Users/tom11w/Projects/Uni/9785-S2-39/scrumtoolkit/','')
"setlocal includeexpr=substitute(v:fname,'^@\/','scrumtoolkit/','')
"set suffixesadd=.js,.tsx,.css,.ts

set listchars=eol:⏎,tab:\|\-▶,trail:~,extends:>,precedes:<,nbsp:␣

"set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
"set list
"Show Hidden Charictors

"noremap <F5> :set list! relativenumber! nu!<CR>
"inoremap <F5> <C-o>:set list! relativenumber! nu!<CR>
"cnoremap <F5> <C-c>:set list! relativenumber! nu!<CR>
noremap <F5> :set list! relativenumber! nu!<CR>:IndentLinesToggle<CR>

"colorscheme codedark

"set notermguicolors


"Tmux stuff

nnoremap <silent> <c-w>h <Cmd>NvimTmuxNavigateLeft<CR>
nnoremap <silent> <c-w>j <Cmd>NvimTmuxNavigateDown<CR>
nnoremap <silent> <c-w>k <Cmd>NvimTmuxNavigateUp<CR>
nnoremap <silent> <c-w>l <Cmd>NvimTmuxNavigateRight<CR>
nnoremap <silent> <C-w>\ <Cmd>NvimTmuxNavigateLastActive<CR>
nnoremap <silent> <C-Space> <Cmd>NvimTmuxNavigateNext<CR>
