setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
setlocal iskeyword+=$
setlocal suffixesadd=.js,.ts,.tsx
setlocal cinoptions+=:0
setlocal shiftwidth=2
compiler prettier

if exists("loaded_matchit")
  let b:match_ignorecase = 0
  let b:match_words = '(:),\[:\],{:},<:>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
endif

function! IncludeExpr()
  let l:result = substitute(v:fname, '^travauxlib', '~/travauxlib/apps', "")
  if !filereadable(expand(l:result))
    return l:result . "/index"
  else
    return l:result
  end
endfunction

setlocal includeexpr=IncludeExpr()
