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

let s:possibilities = [".ts", ".tsx", "/index.ts", "/index.tsx", "/index.js", ".js", ".css", ".scss", ".svg", ".d.ts"]

if !exists("g:loaded_js_gf")
  function! s:Gf()
    if expand("<cWORD>") =~ "@"
      let l:file = expand(substitute( expand("<cWORD>")[1:-3], '@travauxlib', '~/travauxlib/apps', ""))
    else
      let l:file = expand("%:h") . "/" . expand("<cfile>:t")
    endif
    let l:index = 0
    while !len(findfile(l:file . s:possibilities[l:index]))
      let l:index = l:index + 1
      if l:index == len(s:possibilities)
        echo "no luck"
        echom l:file
        return
      endif
    endwhile
    execute "find " . l:file . s:possibilities[l:index]
  endfunction
end
let g:loaded_js_gf=1
nmap <buffer> gf :call <SID>Gf()<CR>
