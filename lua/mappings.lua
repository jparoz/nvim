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


--- Resize window to fit exactly 'textwidth' columns of content
local resize = function()
    local statuscolumn = vim.api.nvim_eval_statusline(
        vim.wo.statuscolumn,
        { use_statuscol_lnum = 1 }
    )

    local tw = vim.bo.textwidth  -- tw is short for textwidth
    local total_width = (tw > 0 and tw or 80) + statuscolumn.width

    vim.cmd("vertical resize " .. total_width)
end
vim.keymap.set("n", "<Leader>=", resize)


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

        vim.keymap.set({"n", "v"}, "ga", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gn", function()
            vim.diagnostic.jump({count = -1})
        end, opts)
        vim.keymap.set("n", "gN", function()
            vim.diagnostic.jump({count = 1})
        end, opts)
    end,
})
