syntax clear
syntax case match
syntax keyword jsStatement if else for while do import return default export case try catch throw finally as async await yield
highlight link jsStatement Statement
syntax match jsString :'[^']*':
syntax match jsString :"[^"]*":
syntax region  jsTemplateString   start=+`+  skip=+\\`+  end=+`+     contains=jsTemplateExpression,jsSpecial extend
syntax region  jsTemplateExpression contained matchgroup=jsTemplateBraces start=+${+ end=+}+ contains=@jsExpression keepend
syntax region jsTemplateString start="`" end="`" contains=jsTemplateExpression extend
syntax cluster jsExpression contains=jsString,jsTemplateString,jsComment,jsBeforeIdentifier,jsObjectKey,jsxBlockName,jsNumber,jsArrowFunctionStart,jsArrow,jsBoolean,jsType,jsLiteral,jsTemplateString
syntax match jsComment ://.*:
syntax region jsComment start="\/\*" end="*/"
syntax match jsBeforeIdentifier :\(let\|const\|function\*\|function\|type\|interface\): nextgroup=jsIdentifier skipwhite
syntax match jsIdentifier :\w\+: contained
syntax match jsObjectKey !\w\+\ze?\?:!
syntax match jsxBlockName :\(\s\|}\|>\)<\/\?\zs[A-Za-z\.]\+\ze\(>\|\n\|\s\):
syntax match jsArrowFunctionStart :(\_[^()]*)\s*\ze=>: contains=@jsExpression
syntax match jsArrow :=>:
syntax match jsNumber :-\?\d\+\(\.\d\+\)\?:
syntax keyword jsLiteral null undefined
syntax keyword jsBoolean false true
syntax keyword jsType string boolean number void object
syntax sync fromstart

highlight link jsType Type
highlight link jsNumber Number
highlight link jsLiteral Special
highlight link jsArrow Special
highlight link jsxBlockName Statement
highlight link jsObjectKey Statement
highlight link jsComment Comment
highlight link jsString String
highlight link jsTemplateString String
highlight link jsBeforeIdentifier Statement
highlight link jsIdentifier Identifier
