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

-- Comment/uncomment
vim.keymap.set({"o", "n", "x"}, "<BSlash>", "gc", {remap = true})
vim.keymap.set("n", "<BSlash><BSlash>", "gcl", {remap = true})


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


vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Make LSP-related mappings when an LSP is attached",
    callback = function(args)
        local function jump_next()
            vim.diagnostic.jump({count = 1, float = true})
        end
        local function jump_prev()
            vim.diagnostic.jump({count = -1, float = true})
        end
        local function code_actions()
            vim.lsp.buf.code_action {apply = true}
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        local opts = { noremap=true, silent=true, buffer = bufnr }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)

        vim.keymap.set("n", "gn", jump_next, opts)
        vim.keymap.set("n", "gN", jump_prev, opts)
        vim.keymap.set({"n", "v"}, "ga", code_actions, opts)

        vim.keymap.set("n", "<CR>", jump_next, opts)
        vim.keymap.set("n", "<S-CR>", jump_prev, opts)
        vim.keymap.set("n", "<C-CR>", code_actions, opts)

        if client.name == "clangd" then
            vim.keymap.set("n", "<F2>", function() vim.cmd [[LspClangdSwitchSourceHeader]] end)
        end
    end,
})
