-- Diagnostic config & handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] =
vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    severity_sort = true,
})

-- Show a border around the hover window
vim.lsp.handlers["textDocument/hover"] =
vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

vim.diagnostic.config({
    -- Only show the first line of diagnostics as virtual text
    virtual_text = {
        format = function(diag)
            return diag.message:match("[^\n]+")
        end,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN]  = "○",
            [vim.diagnostic.severity.INFO]  = "ℹ",
            [vim.diagnostic.severity.HINT]  = "➤",
        },
    },
})

-- LSP configs
vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        require("lsp_signature").on_attach()

        if client.server_capabilities.completionProvider then
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
        end
        if client.server_capabilities.definitionProvider then
            vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
        end

        -- Disable semantic highlighting
        client.server_capabilities.semanticTokensProvider = nil

    end,
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                allFeatures = true,
                overrideCommand = {
                    "cargo", "clippy",
                    "--workspace", "--message-format=json",
                    "--all-targets", "--all-features",
                },
            },
        },
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                unusedLocalExclude = { "_*" },
            },
        },
    },
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--log=info",
    },
})

vim.lsp.config("elixirls", {
    cmd = {
        vim.fn.system("brew --prefix elixir-ls"):gsub("\n", "") ..
        "/libexec/language_server.sh",
    },
})
