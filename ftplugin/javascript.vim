setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
setlocal iskeyword+=$
setlocal suffixesadd=.js,.ts,.tsx,.d.ts
setlocal cinoptions+=:0
setlocal shiftwidth=2
compiler prettier

if exists("loaded_matchit")
  let b:match_ignorecase = 0
  let b:match_words = '(:),\[:\],{:},<:>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
endif

function! IncludeExpr()
  let l:result = expand(substitute(v:fname, '^travauxlib', '~/travauxlib/apps', ""))
  if len(findfile(l:result))
    return l:result
  else
    return l:result . "/index"
  end
endfunction

setlocal includeexpr=IncludeExpr()
