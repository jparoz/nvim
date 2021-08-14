local keymap = require("utils").keymap

keymap("", "U", "<C-r>")
keymap("n", "Y", "y$")
keymap("n", "Q", "@@")

keymap("n", ";", ":")
keymap("n", ":", "<Plug>Sneak_;", {noremap = false})
keymap("x", ";", ":")
keymap("x", ":", "<Plug>Sneak_;", {noremap = false})

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

keymap("n", "<C-Tab>", "gt")
keymap("n", "<C-S-Tab>", "gT")

--- Tabular
keymap("n", "<Tab>=", "<CMD>Tabularize /=<CR>")
keymap("x", "<Tab>=", "<CMD>Tabularize /=<CR>") -- @Fixme: doesn't work great
keymap("n", "<Tab>;", [[<CMD>Tabularize /\w\+:<CR>]])
keymap("x", "<Tab>;", [[<CMD>Tabularize /\w\+:<CR>]]) -- @Fixme: doesn't work great

--- Commentary
keymap("n", "<BSlash>", "<Plug>Commentary", {noremap = false})
keymap("x", "<BSlash>", "<Plug>Commentary", {noremap = false})
keymap("o", "<BSlash>", "<Plug>Commentary", {noremap = false})
keymap("n", "<BSlash><BSlash>", "<Plug>CommentaryLine", {noremap = false})
keymap("n", "<BSlash>u", "<Plug>CommentaryUndo", {noremap = false})

--- Treesitter
require("nvim-treesitter.configs").setup {
    textobjects = {
        select = {
            enable = true,
            -- lookahead = true, -- This might do nothing???
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["am"] = "@class.outer",
                ["im"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@class.outer",
                ["]f"] = "@function.outer",
                ["]["] = "@function.outer",
            },
            goto_next_end = {
                ["]M"] = "@class.outer",
                ["]F"] = "@function.outer",
                ["]]"] = "@function.outer",
            },
            goto_previous_start = {
                ["[m"] = "@class.outer",
                ["[f"] = "@function.outer",
                ["[["] = "@function.outer",
            },
            goto_previous_end = {
                ["[M"] = "@class.outer",
                ["[F"] = "@function.outer",
                ["[]"] = "@function.outer",
            },
        },
    },
}


---- Leader mappings

-- Open a terminal in the current file's directory
keymap("n", "<Leader>t", "<CMD>Terminal<CR>")  -- in current window
keymap("n", "<Leader>s", "<CMD>STerminal<CR>") -- horizontal split
keymap("n", "<Leader>v", "<CMD>VTerminal<CR>") -- vertical split

-- Redo the action in a terminal open in the current tab
-- nnoremap <Enter> :call RedoTerminal()<CR>
keymap("n", "<Leader><Enter>", "<CMD>call RedoTerminal()<CR>")

local luamap = function(mode, lhs, luaname, opts)
    keymap(mode, lhs, "<CMD>lua " .. luaname .. "()<CR>", opts)
end

luamap("n", "<Leader>f", "FZF.find_files")
luamap("n", "<Leader>g", "FZF.live_grep")
luamap("n", "<Leader>h", "FZF.help_tags")
luamap("n", "<Leader>b", "FZF.buffers")

luamap("n", "-", "FZF.file_browser")


--- Buffer-local LSP-related mappings, run when an LSP client is started
function LSP_mappings(client, bufnr)
    local opts = { noremap=true, silent=true, buffer = bufnr }

    luamap("n", "gd", "vim.lsp.buf.definition", opts)
    luamap("n", "<C-]>", "vim.lsp.buf.definition", opts)
    luamap("n", "K", "vim.lsp.buf.hover", opts)
    luamap("n", "gi", "vim.lsp.buf.implementation", opts)
    -- telemap("n", "gi", "lsp_implementations")
    luamap("n", "ga", "vim.lsp.buf.code_action", opts)
    keymap("v", "ga", ":lua vim.lsp.buf.range_code_action()<CR>", opts)
    luamap("n", "gr", "vim.lsp.buf.references", opts)
    -- telemap("n", "gr", "lsp_references")
    luamap("n", "gR", "vim.lsp.buf.rename", opts)
    luamap("n", "gn", "vim.lsp.diagnostic.goto_next", opts)
    luamap("n", "gN", "vim.lsp.diagnostic.goto_prev", opts)
end
