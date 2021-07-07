-- {{{ Shortcuts

local cmd = vim.cmd
local opt = vim.opt
local fn = vim.fn
local g = vim.g
local has = vim.fn.has
local exists = vim.fn.exists

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- }}}

g.mapleader = " "

-- {{{ Packages

require "paq" {
    -- Package manager manages itself
    "savq/paq-nvim",

    -- General/smallish Vim-type upgrades
    "junegunn/vim-slash",
    "justinmk/vim-sneak",
    -- "justinmk/vim-dirvish",
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "tpope/vim-repeat",
    "tpope/vim-commentary",
    "tpope/vim-speeddating",
    "tpope/vim-fugitive",
    "Raimondi/delimitMate",
    "ervandew/supertab",
    "itchyny/lightline.vim",
    -- "ludovicchabant/vim-gutentags",

    -- Specific feature packages
    "neovim/nvim-lspconfig",
    "nvim-lua/completion-nvim",

    -- Language-specific
    "rust-lang/rust.vim",
}

-- }}}

-- {{{ Options

cmd "colorscheme nofrils-dark"
opt.background = "dark"

if has "macunix" then
    if fn.system("scutil --get ComputerName") == "Jesse’s MacBook Air\n" then
        -- computer-specific stuff
    end
end

opt.textwidth = 80
opt.colorcolumn = "+1"

opt.equalalways = false

opt.undofile = true

opt.number = true
opt.scrolloff = 2

opt.showmode = false

opt.tabstop = 4
opt.shiftwidth=4
opt.shiftround = true
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true

opt.list = true
opt.listchars = {
    tab = "· ",
    trail = "·",
    nbsp = "·",
    extends = ">",
    precedes = "<",
}

opt.splitbelow = true
opt.splitright = true

opt.ignorecase = true
opt.smartcase = true

opt.foldmethod = "marker"

-- {{{ Neovim native LSP client

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
    vim.lsp.diagnostic.on_publish_diagnostics,
    { severity_sort = true })

fn.sign_define("LspDiagnosticsSignError",
    { text = "●", texthl = "LspDiagnosticsSignError" })
fn.sign_define("LspDiagnosticsSignWarning",
    { text = "○", texthl = "LspDiagnosticsSignWarning" })
fn.sign_define("LspDiagnosticsSignInformation",
    { text = "ℹ", texthl = "LspDiagnosticsSignInformation" })
fn.sign_define("LspDiagnosticsSignHint",
    { text = "➤", texthl = "LspDiagnosticsSignHint" })

-- }}}

-- {{{ Lightline

g.lightline = {
    colorscheme = "jellybeans",
    active = {
        right = { { "lineinfo" }, { "percent" }, { "filetype" } }
    },
    inactive = {
        right = { { "lineinfo" }, { "percent" } }
    },
}

-- }}}

-- {{{ delimitMate

g.delimitMate_matchpairs = "(:),[:],{:}"
g.delimitMate_quotes = ""
g.delimitMate_expand_cr = 1

-- }}}

-- @Todo: gutentags if necessary
-- @Todo: fzf if necessary

-- }}}

-- {{{ Commands

-- Open a terminal in a new split
cmd [[
command! -nargs=* Terminal split | terminal <args>
command! -nargs=* VTerminal vsplit | terminal <args>
]]

-- Open a terminal in the current file's directory
-- @Todo: Rewrite in Lua (if better)
map("n", "<Leader>m", [[<CMD>let $VIM_CURRENT_DIR=expand('%:p:h')<CR>]]
    .. [[:Terminal<CR>]]
    .. [[:exe "tnoremap <lt>buffer> <lt>Esc> <lt>C-\\><lt>C-n>"<CR>]]
    .. [[i]]
    .. [[ cd $VIM_CURRENT_DIR<CR>]]
    .. [[ clear<CR>]]
    .. [[<C-\><C-N>]]
)

-- Run the last command in an open terminal window in this tab
--[[
function! RedoTerminal()
    let found = 0
    let current_win = win_getid()
    for buf in tabpagebuflist()
        if match(bufname(buf), "^term://") != -1
            let found = 1
            if !(empty(win_findbuf(buf)))
                let job_id = getbufvar(buf, "terminal_job_id")
                -- <Up><Enter>
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

-- nnoremap <Enter> :call RedoTerminal()<CR>
]]

-- }}}

-- {{{ Autocommands

-- Hide line numbers in terminal buffers
cmd "au TermOpen * setlocal nonumber"

-- }}}

-- {{{ Mappings

-- {{{ Commentary
map("n", "<BSlash>", "<Plug>Commentary", {noremap = false})
map("x", "<BSlash>", "<Plug>Commentary", {noremap = false})
map("o", "<BSlash>", "<Plug>Commentary", {noremap = false})
map("n", "<BSlash><BSlash>", "<Plug>CommentaryLine", {noremap = false})
map("n", "<BSlash>u", "<Plug>CommentaryUndo", {noremap = false})
-- }}}

-- Open the current buffer in a new tab
map("n", "<Leader>t", "<CMD>tab sp<CR>")

map("", "U", "<C-r>")
map("n", "Y", "y$")
map("n", "Q", "@@")

map("n", ";", ":")
map("n", ":", ";")
map("x", ";", ":")
map("x", ":", ";")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<C-Tab>", "gt")
map("n", "<C-S-Tab>", "gT")

-- }}}
