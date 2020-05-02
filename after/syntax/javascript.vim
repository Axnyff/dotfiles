syntax clear
syntax case match
syntax keyword jsStatement if else for while do
highlight link jsStatement Statement
syntax match jsComment ://.*:
syntax region jsComment start="\*" end="*/"
highlight  link jsComment Comment
