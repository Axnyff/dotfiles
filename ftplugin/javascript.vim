setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
setlocal iskeyword+=$
setlocal suffixesadd=.js,.ts,.tsx,.d.ts,.jsx
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

if !exists("g:loaded_js_gf")
  function! s:Gf()
    let l:file = expand("<cfile>")

    if len(findfile(l:file))
      execute "find " . l:file
      return
    elseif len(findfile(l:file . "/index"))
      execute "find " . l:file . "/index"
      return
    endif

    if l:file[0] != "." && l:file != "@"

      let l:file = substitute(expand("%:h:p"), '\(pro/\|admin/\|client/\)\?\(src/\).\+', '\1\2', 'g') . l:file
      if len(findfile(l:file))
        execute "find " . l:file
        return
      elseif len(findfile(l:file . "/index"))
        execute "find " . l:file . "/index"
        return
    endif

    endif

    if expand("<cWORD>") =~ "@"
      let l:file = expand(substitute( expand("<cWORD>")[1:-3], '@travauxlib', '~/travauxlib/apps', ""))
    else
      let l:file = simplify(expand("%:h") . "/" . expand("<cfile>"))

    endif
    if !len(findfile(l:file))
      execute "find " . l:file . "/index"
    else
      execute "find " . l:file
    endif
  endfunction
end
let g:loaded_js_gf=1
nmap <buffer> gf :call <SID>Gf()<CR>
