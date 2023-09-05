set nu
set relativenumber
set colorcolumn=80
set cul
set rtp+=/usr/local/opt/fzf


set listchars=eol:⏎,tab:\|\-▶,space:·,trail:~,extends:>,precedes:<,nbsp:␣
set list
noremap <F5> :set list! relativenumber! nu!<CR>
inoremap <F5> <C-o>:set list! relativenumber! nu!<CR>
cnoremap <F5> <C-c>:set list! relativenumber! nu!<CR>
