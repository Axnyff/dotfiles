setlocal makeprg=~/travauxlib/client/node_modules/tslint/bin/tslint\ %\ -c\ ~/travauxlib/client/tslint.json\ -p\ ~/travauxlib/client/tsconfig.json\ --noEmit
setlocal errorformat=%f:[%l,\ %c]:%m
setlocal iskeyword+=$
setlocal suffixesadd=.js,.ts,.tsx
setlocal cinoptions+=:0
setlocal shiftwidth=2
setlocal suffixesadd=.js,.ts,.tsx

