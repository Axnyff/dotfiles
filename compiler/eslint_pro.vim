if exists("current_compiler")
  finish
endif

setlocal makeprg=~/travauxlib/pro/node_modules/eslint/bin/eslint.js\ %\ -f\ \~/.vim/ftplugin/formatter.js
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
CompilerSet makeprg=~/travauxlib/pro/node_modules/eslint/bin/eslint.js\ %\ -f\ \~/.vim/ftplugin/formatter.js
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
let current_compiler="eslint_pro"
