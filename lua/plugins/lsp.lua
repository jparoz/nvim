return { { "mason-org/mason-lspconfig.nvim",

dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
},

config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Configure LSP settings on attach",
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            if client.server_capabilities.completionProvider then
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end
            if client.server_capabilities.definitionProvider then
                vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
            end

            -- Disable semantic highlighting
            client.server_capabilities.semanticTokensProvider = nil

            -- Auto-format on save for selected servers
            if client.name == "rust_analyzer"
                or client.name == "elixirls"
                or client.name == "ruff"
            then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end
        end,
    })

    -- Diagnostic config & handlers
    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            severity_sort = true,
        })

    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

    vim.diagnostic.config({
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

    -- mason-lspconfig setup
    require("mason-lspconfig").setup({
        automatic_installation = false,
        handlers = {
            -- Default handler
            function(server_name)
                require("lspconfig")[server_name].setup({})
            end,

            -- Custom configs
            rust_analyzer = function()
                require("lspconfig").rust_analyzer.setup({
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
            end,

            lua_ls = function()
                require("lspconfig").lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                unusedLocalExclude = { "_*" },
                            },
                        },
                    },
                })
            end,

            clangd = function()
                require("lspconfig").clangd.setup({
                    cmd = {
                        "clangd",
                        "--clang-tidy",
                        "--completion-style=detailed",
                        "--header-insertion=never",
                    },
                })
            end,

            elixirls = function()
                require("lspconfig").elixirls.setup({
                    cmd = {
                        vim.fn.system("brew --prefix elixir-ls"):gsub("\n", "") ..
                        "/libexec/language_server.sh",
                    },
                })
            end,
        },
    })
end,

} }
