syn region  huckBlockComment start="(\*" end="\*)" contains=huckBlockComment
syn region  huckLineComment start="--" end="$"
syn match   huckTodo "@\w\+" containedin=.*Comment.* contained

hi link huckBlockComment huckComment
hi link huckLineComment huckComment
hi link huckComment Comment
