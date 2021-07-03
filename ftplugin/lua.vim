nnoremap <buffer> <Leader><CR> :w<CR>:call deletebufline(bufadd("LOVE output"), 1, "$")<CR>
            \:silent call
            \ jobstart(["/Applications/love.app/Contents/MacOS/love",
            \ getcwd()], {
            \ "on_stdout":"LOVEQuickFix",
            \ "stdout_buffered":1})<CR>
            \ | redraw!

function! LOVEQuickFix(j, d, e)
    cgetexpr a:d
    " if a:d ==# [""]
    "     cclose
    " else
    "     belowright copen
    " endif
endfunction

" setlocal makeprg=lua\ %
" nnoremap <buffer> <CR> :silent! make<CR>
nnoremap <buffer> <CR> :!lua %<CR>

" @Note: these possibly should all say setlocal. I dunno, can't be bothered atm
set errorformat=
set errorformat+=lua:\ %f:%l:%m
set errorformat+=%-G\	[string%.%#
set errorformat+=%-G\	[C]%.%#
set errorformat+=%-Gstack\ traceback:%.%#
set errorformat+=Error:%*[^:]:\ %f:%l:%m
set errorformat+=Error:\ %f:%l:%m
set errorformat+=\	%f:%l:%m
set errorformat+=%f:%l:%m
