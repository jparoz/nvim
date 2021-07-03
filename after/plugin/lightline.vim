" let g:lightline = { 'colorscheme': 'jellybeans' }

function! SynStack()
    if !exists("*synstack")
        return
    endif
    return join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ", ")
endfunc

let g:lightline = {
            \ 'colorscheme': 'jellybeans',
            \ 'active': {
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'filetype' ] ]
            \ },
            \ 'inactive': {
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ] ]
            \ },
            \ 'component_function': {
            \   'SynStack': 'SynStack',
            \ }
            \ }


set noshowmode
