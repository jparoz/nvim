language en_AU

call plug#begin()

Plug 'junegunn/vim-slash'
Plug 'justinmk/vim-sneak'
Plug 'justinmk/vim-dirvish'
Plug 'ervandew/supertab'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
"{{{
nmap <BSlash> <Plug>Commentary
xmap <BSlash> <Plug>Commentary
omap <BSlash> <Plug>Commentary
nmap <BSlash><BSlash> <Plug>CommentaryLine
nmap <BSlash>u <Plug>CommentaryUndo
"}}}
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-fugitive'
Plug 'dense-analysis/ale'
"{{{
let g:ale_linters = {'rust': []}

let g:ale_sign_column_always = 1

let g:ale_sign_error = '●'
let g:ale_sign_warning = '○'
let g:ale_sign_info = '𝒊'

hi link ALEError NONE
"}}}
Plug 'itchyny/lightline.vim'
"{{{
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
"}}}
Plug 'rust-lang/rust.vim'
Plug 'Raimondi/delimitMate'
"{{{
let g:delimitMate_matchpairs = '(:),[:],{:}'
let g:delimitMate_quotes = ''
let g:delimitMate_expand_cr=1
"}}}
Plug 'ludovicchabant/vim-gutentags'
"{{{
if !exists("g:gutentags_project_info")
  let g:gutentags_project_info = []
endif
call add(g:gutentags_project_info, {'type': 'rust', 'file': 'Cargo.toml'})
"}}}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
"{{{
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
"}}}
Plug 'Shougo/deoplete.nvim'
let g:deoplete#enable_at_startup = 1

call plug#end()

colorscheme nofrils-dark
set background=dark

if has('macunix')
    if match(system('scutil --get ComputerName'), "Jesse’s MacBook Air") != -1
        e /Users/jlp/dev/projects
    endif
endif

set textwidth=80
set colorcolumn=+1

set noequalalways

set undofile

set number
set scrolloff=2

set tabstop=4 shiftwidth=4 shiftround expandtab smarttab autoindent
set list listchars=tab:·\ ,trail:·,nbsp:·,extends:>,precedes:<
set splitbelow splitright
set ignorecase smartcase
set foldmethod=marker

" Leader
let mapleader = " "

" Open the current buffer in a new tab
nnoremap <Leader>t :tab sp<CR>

" Open a terminal in a new split
command! -nargs=* T split | terminal <args>
command! -nargs=* VT vsplit | terminal <args>

" Open a terminal in the current file's directory
nnoremap <Leader>m :let $VIM_CURRENT_DIR=expand('%:p:h')<CR>
            \:T<CR>
            \:exe "tnoremap <lt>buffer> <lt>Esc> <lt>C-\\><lt>C-n>"<CR>
            \i
            \ cd $VIM_CURRENT_DIR<CR>
            \ clear<CR>
            \<C-\><C-N>

" Hide line numbers in terminal buffers
au TermOpen * setlocal nonumber

" Run the last command in an open terminal window in this tab
function! RedoTerminal()
    let found = 0
    let current_win = win_getid()
    for buf in tabpagebuflist()
        if match(bufname(buf), "^term://") != -1
            let found = 1
            if !(empty(win_findbuf(buf)))
                let job_id = getbufvar(buf, "terminal_job_id")
                " <Up><Enter>
                call chansend(job_id, "[A")

                let wins = win_findbuf(buf)
                if !empty(wins)
                    call win_gotoid(wins[0])
                    normal! G
                    call win_gotoid(current_win)
                endif
            endif
        endif
    endfor

    if !found
        echo "No terminal window open"
    else
        echo ""
    endif
endfunction

" nnoremap <Enter> :call RedoTerminal()<CR>

noremap U <C-r>
nnoremap Y y$
nnoremap Q @@

nnoremap ; :
nnoremap : ;
xnoremap ; :
xnoremap : ;

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
