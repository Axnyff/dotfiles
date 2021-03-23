set makeprg=make\ compile\ file=%
set errorformat=%f\:%l:%c:\ error:\ %m,%-G%.%#,%-G%.%#
function! Make()
  execute(":silent make")
  call feedkeys("\<C-l>")
  if (len(getqflist()) != 0)
    copen
    cfirst
  else 
    cclose
  endif
endfunction

map <buffer> m<Enter> :call Make()<CR>
