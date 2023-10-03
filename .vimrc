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
let mapleader = "\<Backslash>"
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
" Bow before Tim Pope
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
call minpac#add('tpope/vim-eunuch')

call minpac#add('whiteinge/diffconflicts')
call minpac#add('vim-airline/vim-airline')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')

call minpac#add('bakpakin/fennel.vim')
call minpac#add('bronson/vim-visual-star-search')

" Minpac options
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

command! Pr execute "Git log origin/master..HEAD --name-status | only"
command! Gblame execute "Git blame"

command!  -nargs=1 -complete=file C execute "new " . <q-args> . "| only"

" Netrw options
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_winsize='30'

" Binding FZF
nnoremap <C-p> :<C-u>FZF<CR>

filetype plugin on
set noswapfile
set path=.,,
set wildignore=**/node_modules/*
set hidden
set mouse=a
set cursorline nocursorline
set tags=./tags,tags;$HOME,~/travauxlib/.git/tags
set expandtab

" The Silver Searcher
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --hidden
endif


xnoremap <silent> p p:if v:register == '"'<Bar>let @@=@0<Bar>endif<cr>
nnoremap gF <C-W>v<C-W><C-W>gf

" Properly set up undodir
set undofile
set undodir=~/.vim/undodir

let g:local = "postgresql://hemea@localhost/hemea"

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

" improve diff
if has("patch-8.1.0360")
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif

" edit vimrc
nnoremap cv :e $MYVIMRC<CR>
nnoremap cd :e ~/todos/todos.md<CR>

" improve gx
function! s:Gx()
  let l:url = expand("<cWORD>")
  execute "!xdg-open " . shellescape(l:url, 1)
endfunction

nmap gx :call <SID>Gx()<CR>

if exists(':tnoremap')
    tnoremap <Esc> <C-\><C-n>
endif


autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

" interactive mode: make it read the bashrc
set shellcmdflag=-ic

function! s:CompleteYank()
    redir @n | silent! :'<,'>number | redir END
    let filename=expand("%")
    let decoration=repeat('-', len(filename)+1)
    let @+=decoration . "\n" . filename . ':' . "\n" . decoration . "\n" . @n
endfunction 

vmap gy :call <SID>CompleteYank()<CR>

autocmd BufEnter * hi MatchParen cterm=none ctermbg=blue ctermfg=blue

inoremap <expr> <C-f> expand("%:t:r")
nnoremap gs :0Git<cr>:normal gU<cr>
