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
"{{{ Commentary

nmap <BSlash> <Plug>Commentary
xmap <BSlash> <Plug>Commentary
omap <BSlash> <Plug>Commentary
nmap <BSlash><BSlash> <Plug>CommentaryLine
nmap <BSlash>u <Plug>CommentaryUndo

"}}}
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
"{{{ LightLine

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
"{{{ delimitMate

let g:delimitMate_matchpairs = '(:),[:],{:}'
let g:delimitMate_quotes = ''
let g:delimitMate_expand_cr=1

"}}}
Plug 'ludovicchabant/vim-gutentags'
"{{{ Gutentags
if !exists("g:gutentags_project_info")
  let g:gutentags_project_info = []
endif
call add(g:gutentags_project_info, {'type': 'rust', 'file': 'Cargo.toml'})
"}}}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"{{{ FZF

function! s:fzf_project_sink(line)
    exe "cd" ("~/dev/projects/" . a:line)
endfunction

let s:fzf_project_dir = $HOME . "/dev/projects/"

command! Projects call fzf#run(fzf#wrap({
            \ 'source': 'ls ' . s:fzf_project_dir,
            \ 'sink': function("s:fzf_project_sink"),
            \ 'options': [
            \   '--prompt=Projects>',
            \   "--preview=env\ CLICOLOR_FORCE=1\ ls\ -G\ '" . s:fzf_project_dir . "'{}",
            \ ],
            \ 'window': {'width': 0.8, 'height': 0.6},
            \ }))

nnoremap - :Files<CR>

"}}}

if has("nvim-0.5.0")
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
else
    Plug 'dense-analysis/ale'
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
    Plug 'Shougo/deoplete.nvim'
    let g:deoplete#enable_at_startup = 1
endif

call plug#end()


if has("nvim-0.5.0")
"{{{ Neovim native LSP client

lua << EOF
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- require("completion").on_attach(client, bufnr) -- completion-nvim

    local function set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    set_keymap('n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    set_keymap('v', 'ga', ':lua vim.lsp.buf.range_code_action()<CR>', opts)
    set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    set_keymap('n', 'gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    set_keymap('n', 'gN', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    -- set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    -- set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "rust_analyzer" }
for _, lsp in ipairs(servers) do
    local nvim_lsp = require('lspconfig')

    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        -- on_attach = require("completion").on_attach,
        flags = {
            debounce_text_changes = 150,
        }
    }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        severity_sort = true,
    })

EOF

sign define LspDiagnosticsSignError text=● texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=○ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text=ℹ texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text=➤ texthl=LspDiagnosticsSignHint linehl= numhl=

"}}}
else
"{{{ ALE

let g:ale_linters = {'rust': []}

let g:ale_sign_column_always = 1

let g:ale_sign_error = '●'
let g:ale_sign_warning = '○'
let g:ale_sign_info = '𝒊'

hi link ALEError NONE

"}}}
"{{{ LanguageClient-neovim

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
end

colorscheme nofrils-dark
set background=dark

if has('macunix')
    if match(system('scutil --get ComputerName'), "Jesse’s MacBook Air") != -1
        " Projects
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
