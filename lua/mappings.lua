local keymap = require("utils").keymap

keymap("", "U", "<C-r>")
keymap("n", "Y", "y$")
keymap("n", "Q", "@@")

keymap("n", ";", ":")
keymap("n", ":", ";")
keymap("x", ";", ":")
keymap("x", ":", ";")

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

keymap("n", "<C-Tab>", "gt")
keymap("n", "<C-S-Tab>", "gT")

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

-- Open the current buffer in a new tab
keymap("n", "<Leader>t", "<CMD>tab split<CR>")

-- Open a terminal in the current file's directory, in a new split
keymap("n", "<Leader>m", "<CMD>STerminal<CR>")

--- Telescope
local telemap = function(mode, lhs, telename, opts, teleopts)
    keymap(mode, lhs,
        "<CMD>lua require('telescope.builtin')." .. telename
            .. "(" .. (teleopts and teleopts or "") .. ")<CR>", opts)
end

telemap("n", "<Leader>f", "find_files")
telemap("n", "<Leader>g", "live_grep")
telemap("n", "<Leader>h", "help_tags")
telemap("n", "<Leader>b", "buffers")

telemap("n", "-", "file_browser", nil, "{hidden = true, follow = true, dir_icon = '📁'}")


--- Buffer-local LSP-related mappings, run when an LSP client is started
function LSP_mappings(client, bufnr)
    local opts = { noremap=true, silent=true, buffer = bufnr }

    keymap("n", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", opts)
    keymap("n", "<C-]>", "<CMD>lua vim.lsp.buf.definition()<CR>", opts)
    keymap("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>", opts)
    -- keymap("n", "gi", "<CMD>lua vim.lsp.buf.implementation()<CR>", opts)
    telemap("n", "gi", "lsp_implementations")
    keymap("n", "ga", "<CMD>lua vim.lsp.buf.code_action()<CR>", opts)
    keymap("v", "ga", ":lua vim.lsp.buf.range_code_action()<CR>", opts)
    -- keymap("n", "gr", "<CMD>lua vim.lsp.buf.references()<CR>", opts)
    telemap("n", "gr", "lsp_references")
    keymap("n", "gR", "<CMD>lua vim.lsp.buf.rename()<CR>", opts)
    keymap("n", "gn", "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    keymap("n", "gN", "<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
end
