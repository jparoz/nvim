local servers = {
    -- "rust_analyzer",
    "rls",
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

-- @Note: Sumneko Lua has been performing really poorly, mostly not working,
--        and just making my laptop whir. For now, just disabling.
if false then -- sumneko Lua LSP setup
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
                    globals = {"vim", "love", "hs"},
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

        on_init = function(client)
            local pwd = vim.fn.getcwd()
            local lua_version = "LuaJIT"
            if pwd:find(".hammerspoon") then
                lua_version = "Lua 5.4"
            end

            client.config.settings.Lua.runtime.version = lua_version
            client.notify("workspace/didChangeConfiguration")
            return true
        end,

        flags = {
            debounce_text_changes = 150,
        }
    }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { severity_sort = true })

vim.fn.sign_define("DiagnosticSignError",
    { text = "●", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
    { text = "○", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
    { text = "ℹ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
    { text = "➤", texthl = "DiagnosticSignHint" })
