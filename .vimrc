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
set hlsearch
set cursorline
set autoindent
set tabstop=2
set shiftwidth=2
hi Comment guifg=#ABCDEF
set list
set listchars=tab:␉·,eol:¬,nbsp:☠,trail:.,
let mapleader = "\<Space>"
set colorcolumn="#303030"

set shortmess=atIO

"autoread modified files
set autoread
set autowrite
set autowriteall
set updatetime=100
autocmd FileChangedShell,FocusGained,CursorHold ?* if getcmdwintype() == '' | checktime | endif

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

" PLUGIN SECTION
packadd minpac
call minpac#init()
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-fireplace')
call minpac#add('tpope/vim-dadbod')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-sensible')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-git')
call minpac#add('tpope/vim-rhubarb')
call minpac#add('tpope/vim-dispatch')
call minpac#add('leafgarland/typescript-vim')
call minpac#add('pangloss/vim-javascript')
call minpac#add('mxw/vim-jsx')
call minpac#add('vim-airline/vim-airline')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('bronson/vim-visual-star-search')


" Minpac options
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

" Netrw options
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_winsize='30'

" Binding FZF
nnoremap <C-p> :<C-u>FZF<CR>

filetype plugin on
set noswapfile
set path=.,,
autocmd VimLeave * call system("xsel -ib", getreg('+'))
set wildignore=**/node_modules/*
set hidden
set mouse=a
set cursorline nocursorline
set tags=./tags,tags;$HOME,~/travauxlib/.git/tags
set expandtab

" The Silver Searcher
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif


xnoremap <silent> p p:if v:register == '"'<Bar>let @@=@0<Bar>endif<cr>

" Properly set up undodir
set undofile
set undodir=~/.vim/undodir

let g:local = "postgresql://play@localhost/travauxlib"

function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup end
