syn match TodoUnfinished    /- .*$/
syn match TodoFinished      /x .*$/

hi def link TodoUnfinished Normal
hi def link TodoFinished NonText
