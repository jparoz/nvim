return { { "neovim/nvim-lspconfig",

init = function()
    local lspconfig = require('lspconfig')

    -- Map buffer local keybindings when the language server attaches
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local bufnr = args.buf
            local winid = vim.fn.bufwinid(bufnr)
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            if client.server_capabilities.completionProvider then
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end
            if client.server_capabilities.definitionProvider then
                vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
            end

            -- if client.server_capabilities.documentFormattingProvider then
            if client.name == "rust_analyzer"
                or client.name == "elixirls"
            then
                -- Automatically format on save
                vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
            end

            vim.wo[winid].signcolumn = "yes"
        end,
    })

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

    -- Show a border around the hover window
    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

    -- Only show the first line of diagnostics as virtual text
    vim.diagnostic.config({
        virtual_text = {
            format = function(diag)
                return diag.message:match("[^\n]+")
            end
        }
    })


    -- Server configuration below

    -- rust-analyzer
    lspconfig.rust_analyzer.setup {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    allFeatures = true,
                    -- Show clippy messages
                    overrideCommand = {
                        "cargo", "clippy", "--workspace", "--message-format=json",
                        "--all-targets", "--all-features",
                    }
                }
            }
        },
    }

    -- Haskell Language Server
    lspconfig.hls.setup {
        filetypes = { "haskell", "lhaskell", "cabal" },
    }

    -- TeXLab
    lspconfig.texlab.setup {
        settings = {
            texlab = {
                build = {
                    -- args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-outdir=output", "%f" },
                    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                    executable = "latexmk",
                    forwardSearchAfter = false,
                    onSave = false,
                },
                chktex = {
                    -- onOpenAndSave = true,
                },
                forwardSearch = {
                    executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                    args = { "-g", "%l", "%p", "%f" },
                },
            },
        },
    }

    -- marksman (markdown)
    lspconfig.marksman.setup {
        -- Development version
        -- cmd = { vim.env["HOME"] .. "/dev/projects/marksman/Marksman/bin/Debug/net7.0/marksman", "server" },
    }

    -- lua-language-server
    lspconfig.lua_ls.setup {
        settings = {
            Lua = {
                diagnostics = {
                    unusedLocalExclude = { "_*" },
                },
            },
        },
    }

    -- vscode-json-languageserver
    lspconfig.jsonls.setup {}

    -- elixir-ls
    lspconfig.elixirls.setup {
        cmd = {
            vim.fn.system("brew --prefix elixir-ls"):gsub("\n", "") ..
            "/libexec/language_server.sh",
        },
    }

    -- fsautocomplete
    lspconfig.fsautocomplete.setup {}

end,

} }
