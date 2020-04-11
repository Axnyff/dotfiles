setlocal makeprg=eslint\ %\ -f\ ~/.vim/compiler/eslint_formatter.js\ --fix
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
