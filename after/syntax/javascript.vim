syntax clear
syntax case match
syntax keyword jsStatement if else for while do import return default export case try catch throw finally as async await yield
highlight link jsStatement Statement
syntax match jsString :'[^']*':
syntax match jsString :"[^"]*":
syntax region jsTemplateExpression start=/\${/ end=/}/ contained contains=jsString,jsTemplateString,jsComment,jsBeforeIdentifier,jsObjectKey,jsxBlockName,jsNumber,jsArrowFunctionStart,jsArrow
syntax region jsTemplateString start="`" end="`" contains=jsTemplateExpression

syntax match jsComment ://.*:
syntax region jsComment start="\/\*" end="*/"
syntax match jsBeforeIdentifier :\(const\|function\*\|function\|type\|interface\): nextgroup=jsIdentifier skipwhite
syntax match jsIdentifier :\w\+: contained
syntax match jsObjectKey ?\w\+:?
syntax match jsxBlockName :\(\s\|>\)<\/\?\zs\w\+\ze\(>\|\n\|\s\):
syntax match jsArrowFunctionStart :(\_[^()]*)\s*\ze=>:
syntax match jsArrow :=>:
syntax match jsNumber :-\?\d\+\(\.\d\+\)\?:
syntax keyword jsBoolean false true
syntax keyword jsType string boolean number void

highlight link jsType Type
highlight link jsNumber Number
highlight link jsArrow Special
highlight link jsxBlockName Statement
highlight link jsObjectKey Statement
highlight link jsComment Comment
highlight link jsString String
highlight link jsTemplateString String
highlight link jsBeforeIdentifier Statement
highlight link jsIdentifier Identifier
