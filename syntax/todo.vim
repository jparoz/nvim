syn match TodoUnfinished    /^\s*- .*$/
syn match TodoFinished      /^\s*x .*$/

hi def link TodoUnfinished Normal
hi def link TodoFinished NonText
