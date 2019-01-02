setlocal iskeyword+=$
setlocal suffixesadd=.js,.ts,.tsx,.d.ts
setlocal cinoptions+=:0
setlocal shiftwidth=2
function! IncludeExpr()
  let l:result = expand(substitute(v:fname, '^travauxlib', '~/travauxlib/apps', ""))
  echom l:result
  echom findfile(l:result)
  echom !findfile(l:result)
  if len(findfile(l:result))
    return l:result
  else
    return l:result . "/index"
  end
endfunction

setlocal includeexpr=IncludeExpr()
compiler prettier
