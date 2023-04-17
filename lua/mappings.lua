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


--- Resize window to exactly 'textwidth'
local resize = '\z
<CMD>exec "vertical resize " . \z
    (\z
        (&textwidth > 0 ? &textwidth : 80) \z
         + &numberwidth + (&signcolumn == "yes" ? 2 : 0)\z
    )<CR>'
vim.keymap.set("n", "<Leader>=", resize)


--- Swap the buffers of two windows
local swapBuffers = require("windows").swapBuffers
for i=1, 9 do
    vim.keymap.set("n", "<Leader>"..i, function() swapBuffers(i) end)
end


--- Buffer-local LSP-related mappings, run when an LSP client is started
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        local opts = { noremap=true, silent=true, buffer = bufnr }

        if client.name == "texlab" then
            vim.keymap.set("n", "K", function() vim.cmd("TexlabForward") end, opts)
        else
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end

        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
        vim.keymap.set("v", "ga", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "gN", vim.diagnostic.goto_prev, opts)
    end,
})
