local keymap = require("utils").keymap

local cmdmap = function(mode, lhs, cmd, opts)
    keymap(mode, lhs, "<CMD>" .. cmd .. "<CR>", opts)
end

local luamap = function(mode, lhs, luaname, opts, arg)
    arg = arg or ""

    cmdmap(mode, lhs, "lua " .. luaname .. "(" .. arg .. ")", opts)
end

keymap("n", "U", "<C-r>")
keymap("n", "Y", "y$")
keymap("n", "Q", "@@")

keymap("nx", ";", ":")
keymap("nx", ":", "<Plug>Sneak_;", {noremap = false})

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

keymap("n", "<C-Tab>", "gt")
keymap("n", "<C-S-Tab>", "gT")

-- This is to help stop a common mistake with current Hammerspoon config
keymap("i", "<C-;>", "<ESC>:")

--- Tabular
cmdmap("nx", "<Tab>=", "Tabularize /=") -- @Fixme: x-mode doesn't work great
cmdmap("nx", "<Tab>;", [[Tabularize /\w\+:]]) -- @Fixme: x-mode doesn't work great

--- Commentary
keymap("onx", "<BSlash>", "<Plug>Commentary", {noremap = false})
keymap("n", "<BSlash><BSlash>", "<Plug>CommentaryLine", {noremap = false})

--- Treesitter text objects
luamap("o", "af", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@function.outer", "o"')
luamap("o", "if", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@function.inner", "o"')
luamap("o", "am", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@class.outer", "o"')
luamap("o", "im", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@class.inner", "o"')
luamap("o", "aa", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@parameter.outer", "o"')
luamap("o", "ia", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@parameter.inner", "o"')

luamap("x", "af", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@function.outer", "x"')
luamap("x", "if", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@function.inner", "x"')
luamap("x", "am", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@class.outer", "x"')
luamap("x", "im", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@class.inner", "x"')
luamap("x", "aa", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@parameter.outer", "x"')
luamap("x", "ia", "require'nvim-treesitter.textobjects.select'.select_textobject", {silent = true}, '"@parameter.inner", "x"')

cmdmap("n", "]m", "TSTextobjectGotoNextStart @class.outer")
cmdmap("n", "]f", "TSTextobjectGotoNextStart @function.outer")
cmdmap("n", "][", "TSTextobjectGotoNextStart @function.outer")

cmdmap("n", "]M", "TSTextobjectGotoNextEnd @class.outer")
cmdmap("n", "]F", "TSTextobjectGotoNextEnd @function.outer")
cmdmap("n", "]]", "TSTextobjectGotoNextEnd @function.outer")

cmdmap("n", "[m", "TSTextobjectGotoPreviousStart @class.outer")
cmdmap("n", "[f", "TSTextobjectGotoPreviousStart @function.outer")
cmdmap("n", "[[", "TSTextobjectGotoPreviousStart @function.outer")

cmdmap("n", "[M", "TSTextobjectGotoPreviousEnd @class.outer")
cmdmap("n", "[F", "TSTextobjectGotoPreviousEnd @function.outer")
cmdmap("n", "[]", "TSTextobjectGotoPreviousEnd @function.outer")

---- Leader mappings

-- Open a terminal in the current file's directory
cmdmap("n", "<Leader>t", "Terminal")  -- in current window
cmdmap("n", "<Leader>s", "STerminal") -- horizontal split
cmdmap("n", "<Leader>v", "VTerminal") -- vertical split

-- open Fugitive status window
cmdmap("n", "<Leader>-", "below Git")

-- Redo the action in a terminal open in the current tab
-- nnoremap <Enter> :call RedoTerminal()<CR>
cmdmap("n", "<Leader><Enter>", "call RedoTerminal()")

luamap("n", "<Leader>f", "FZF.find_files")
luamap("n", "<Leader>g", "FZF.live_grep")
luamap("n", "<Leader>h", "FZF.help_tags")
luamap("n", "<Leader>b", "FZF.buffers")

luamap("n", "-", "FZF.file_browser")

--- Resize window to 100 wide
cmdmap("n", "<Leader>=", 'exec "vertical resize " . ' ..
    '(100 + &numberwidth + (&signcolumn == "yes" ? 2 : 0))')

--- Buffer-local LSP-related mappings, run when an LSP client is started
function LSP_mappings(client, bufnr)
    local opts = { noremap=true, silent=true, buffer = bufnr }

    luamap("n", "gd", "vim.lsp.buf.definition", opts)
    luamap("n", "<C-]>", "vim.lsp.buf.definition", opts)
    luamap("n", "K", "vim.lsp.buf.hover", opts)
    luamap("n", "gi", "vim.lsp.buf.implementation", opts)
    -- telemap("n", "gi", "lsp_implementations")
    luamap("n", "ga", "vim.lsp.buf.code_action", opts)
    luamap("v", "ga", "vim.lsp.buf.range_code_action", opts)
    luamap("n", "gr", "vim.lsp.buf.references", opts)
    -- telemap("n", "gr", "lsp_references")
    luamap("n", "gR", "vim.lsp.buf.rename", opts)
    luamap("n", "gn", "vim.lsp.diagnostic.goto_next", opts)
    luamap("n", "gN", "vim.lsp.diagnostic.goto_prev", opts)
end
