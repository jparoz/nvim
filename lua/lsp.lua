local servers = {
    "rust_analyzer",
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
for _, lsp in ipairs(servers) do
    local nvim_lsp = require('lspconfig')

    nvim_lsp[lsp].setup {
        on_attach = function(client, bufnr)
            if LSP_mappings then LSP_mappings(client, bufnr) end
            vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
        end,

        flags = {
            debounce_text_changes = 150,
        },
    }
end

do -- sumneko Lua LSP setup
    local sumneko_root_path = vim.env.HOME .. "/dev/projects/lua-language-server"
    local sumneko_binary = sumneko_root_path .. "/bin/macOS/lua-language-server"

    require("lspconfig").sumneko_lua.setup {
        cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT", -- depends which file we're editing
                    path = vim.split(package.path, ";"),
                },
                diagnostics = {
                    globals = {"vim", "love"},
                },
                workspace = {
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    },
                },
            },
        },
        on_attach = function(client, bufnr)
            if LSP_mappings then LSP_mappings(client, bufnr) end
            vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
        end,

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
