syn region  huckComment start="(\*" end="\*)" contains=huckComment
syn match   huckTodo "@\w\+" containedin=.*Comment.* contained

hi link huckComment Comment
