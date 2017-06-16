setlocal makeprg=eslint\ %\ -f\ compact\ \\\|\ head\ -n\ -2
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
setlocal noexpandtab
setlocal iskeyword+=$
