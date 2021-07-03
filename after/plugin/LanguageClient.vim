let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'stable', 'rls'],
            \ }

let g:LanguageClient_diagnosticsDisplay = {
            \     1: {
            \         "name": "Error",
            \         "texthl": "LanguageClientError",
            \         "signText": "●",
            \         "signTexthl": "LanguageClientErrorSign",
            \         "virtualTexthl": "Virtual",
            \     },
            \     2: {
            \         "name": "Warning",
            \         "texthl": "LanguageClientWarning",
            \         "signText": "○",
            \         "signTexthl": "LanguageClientWarningSign",
            \         "virtualTexthl": "Virtual",
            \     },
            \     3: {
            \         "name": "Information",
            \         "texthl": "LanguageClientInfo",
            \         "signText": "ℹ",
            \         "signTexthl": "LanguageClientInfoSign",
            \         "virtualTexthl": "Virtual",
            \     },
            \     4: {
            \         "name": "Hint",
            \         "texthl": "LanguageClientInfo",
            \         "signText": "➤",
            \         "signTexthl": "LanguageClientInfoSign",
            \         "virtualTexthl": "Virtual",
            \     },
            \ }

let g:LanguageClient_hideVirtualTextsOnInsert = 1

function LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nmap <buffer> <silent> K <Plug>(lcn-hover)
        nmap <buffer> <silent> <F2> <Plug>(lcn-rename)
        nmap <buffer> <silent> gd <Plug>(lcn-definition)
        nmap <buffer> <silent> <C-]> <Plug>(lcn-definition)
    endif
endfunction

autocmd FileType * call LC_maps()
