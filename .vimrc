set guifont=Consolas:h10
set relativenumber
set nu
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set encoding=utf-8
syn on
colorscheme slate
set noexpandtab
set hlsearch
set cursorline
set autoindent
set tabstop=4
set shiftwidth=4
hi Comment guifg=#ABCDEF
set list
set listchars=tab:␉·,eol:¬,nbsp:☠,trail:·,
let mapleader = "\<Space>"
set colorcolumn="#303030"


nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '`', "#" ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

map Y y$
nnoremap <Leader><Leader> :set cursorcolumn!<CR>

call pathogen#infect()
let g:netrw_liststyle=3
let g:netrw_banner=0
filetype plugin on
set noswapfile
set path=.,,
autocmd VimLeave * call system("xsel -ib", getreg('+'))
set wildignore=**/node_modules/*
set hidden
set expandtab
set mouse=a
set cursorline nocursorline
