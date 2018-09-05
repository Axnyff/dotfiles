setlocal makeprg=~/travauxlib/client/node_modules/eslint/bin/eslint.js\ %\ -f\ compact\ --fix\ \\\|\ head\ -n\ -2
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
setlocal iskeyword+=$
setlocal suffixesadd=.js,.ts,.tsx
setlocal cinoptions+=:0
setlocal shiftwidth=2

if exists("loaded_matchit")
  let b:match_ignorecase = 0
  let b:match_words = '(:),\[:\],{:},<:>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
endif
