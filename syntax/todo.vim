syn match TodoUnfinished    /^\s*- .*$/
syn match TodoFinished      /^\s*x .*$/
syn match TodoTodo          "@\w\+" containedin=TodoUnfinished contained

hi def link TodoUnfinished  Normal
hi def link TodoFinished    NonText
hi def link TodoTodo        Todo
