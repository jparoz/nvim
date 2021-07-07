local keymap = function(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end

    if options.buffer then
        local buffer = options.buffer
        options.buffer = nil
        vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, options)
    else
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end
end

-- Open the current buffer in a new tab
keymap("n", "<Leader>t", "<CMD>tab sp<CR>")

-- Open a terminal in the current file's directory
keymap("n", "<Leader>m", "<CMD>STerminal<CR>")

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

-- Buffer-local LSP-related mappings, run when an LSP client is started
function lsp_mappings(client, bufnr)
    local opts = { noremap=true, silent=true, buffer = bufnr }

    keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    keymap('n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    keymap('v', 'ga', ':lua vim.lsp.buf.range_code_action()<CR>', opts)
    keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    keymap('n', 'gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    keymap('n', 'gN', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
end

-- Commentary
keymap("n", "<BSlash>", "<Plug>Commentary", {noremap = false})
keymap("x", "<BSlash>", "<Plug>Commentary", {noremap = false})
keymap("o", "<BSlash>", "<Plug>Commentary", {noremap = false})
keymap("n", "<BSlash><BSlash>", "<Plug>CommentaryLine", {noremap = false})
keymap("n", "<BSlash>u", "<Plug>CommentaryUndo", {noremap = false})
