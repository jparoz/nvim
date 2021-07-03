setlocal tw=0 colorcolumn=0
setlocal linebreak showbreak=\ \  breakindent breakindentopt="shift:2,sbr"

nnoremap <buffer> j gj
nnoremap <buffer> k gk

function! CheckUncheck()
    let s:matched = matchstr(getline('.'), "[-x] ")
    if s:matched == "- "
        s/\- /x /
    elseif s:matched == "x "
        s/x /- /
    endif
endfunction

nnoremap <buffer> <CR> :silent! call CheckUncheck()<CR>0
