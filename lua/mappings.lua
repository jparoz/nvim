local cmdmap = function(mode, lhs, cmd, opts)
    vim.keymap.set(mode, lhs, "<CMD>" .. cmd .. "<CR>", opts)
end

vim.keymap.set("n", "U", "<C-r>")
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "Q", "@@")

vim.keymap.set({"n", "x"}, ";", ":")
vim.keymap.set({"n", "x"}, ":", "<Plug>Sneak_;", {remap = true})

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-Tab>", "gt")
vim.keymap.set("n", "<C-S-Tab>", "gT")

-- This is to help stop a common mistake with current Hammerspoon config
vim.keymap.set("i", "<C-;>", "<ESC>:")


--- Tabular
-- @Fixme: x-mode doesn't work great
cmdmap({"n", "x"}, "<Tab>=", "Tabularize /=")
cmdmap({"n", "x"}, "<Tab>;", [[Tabularize /\w\+:]])


--- Commentary
vim.keymap.set({"o", "n", "x"}, "<BSlash>", "<Plug>Commentary", {remap = true})
vim.keymap.set("n", "<BSlash><BSlash>", "<Plug>CommentaryLine", {remap = true})


--- Treesitter text objects
local select_textobject = require("nvim-treesitter.textobjects.select").select_textobject
for _, mode in ipairs({"o", "x"}) do
    vim.keymap.set(mode, "af", function() select_textobject("@function.outer", mode) end, {silent = true})
    vim.keymap.set(mode, "if", function() select_textobject("@function.inner", mode) end, {silent = true})
    vim.keymap.set(mode, "am", function() select_textobject("@class.outer", mode) end, {silent = true})
    vim.keymap.set(mode, "im", function() select_textobject("@class.inner", mode) end, {silent = true})
    vim.keymap.set(mode, "aa", function() select_textobject("@parameter.outer", mode) end, {silent = true})
    vim.keymap.set(mode, "ia", function() select_textobject("@parameter.inner", mode) end, {silent = true})
end

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

vim.keymap.set("n", "<Leader>f", FZF.find_files)
vim.keymap.set("n", "<Leader>g", FZF.live_grep)
vim.keymap.set("n", "<Leader>h", FZF.help_tags)
vim.keymap.set("n", "<Leader>b", FZF.buffers)

vim.keymap.set("n", "-", FZF.file_browser)


--- Resize window to exactly 'textwidth'
cmdmap("n", "<Leader>=", 'exec "vertical resize " . ' ..
    '(' ..
        '(&textwidth > 0 ? &textwidth : 80)' ..
        ' + &numberwidth + (&signcolumn == "yes" ? 2 : 0)' ..
    ')')


--- Swap the buffers of two windows
local swapBuffers = require("windows").swapBuffers
for i=1, 9 do
    vim.keymap.set("n", "<Leader>"..i, function() swapBuffers(i) end)
end


--- Buffer-local LSP-related mappings, run when an LSP client is started
function LSP_mappings(client, bufnr)
    local opts = { noremap=true, silent=true, buffer = bufnr }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    -- vim.keymap.set("n", "gi", lsp_implementations, opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
    vim.keymap.set("v", "ga", vim.lsp.buf.range_code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    -- vim.keymap.set("n", "gr", lsp_references, opts)
    vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "gN", vim.diagnostic.goto_prev, opts)
end
