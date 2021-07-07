local servers = {
    "rust_analyzer",
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
for _, lsp in ipairs(servers) do
    local nvim_lsp = require('lspconfig')

    nvim_lsp[lsp].setup {
        on_attach = function(client, bufnr)
            if lsp_mappings then lsp_mappings(client, bufnr) end
            -- vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

            -- completion-nvim
            -- return require("completion").on_attach(client, bufnr)
        end,
        -- on_attach = require("completion").on_attach,

        flags = {
            debounce_text_changes = 150,
        }
    }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { severity_sort = true })

vim.fn.sign_define("LspDiagnosticsSignError",
    { text = "●", texthl = "LspDiagnosticsSignError" })
vim.fn.sign_define("LspDiagnosticsSignWarning",
    { text = "○", texthl = "LspDiagnosticsSignWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation",
    { text = "ℹ", texthl = "LspDiagnosticsSignInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint",
    { text = "➤", texthl = "LspDiagnosticsSignHint" })
