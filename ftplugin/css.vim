" set makeprg=stylelint\ %\ --custom-formatter\ ~/.vim/ftplugin/css_formatter.js
setlocal errorformat=%f\ %l:%c\ %m
setlocal shiftwidth=2
compiler prettier
