function! Make()
  execute(":silent !curl http://localhost:9000")
endfunction

map <buffer> m<Enter> :call Make()<CR>
