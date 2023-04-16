local lspconfig = require('lspconfig')

-- Flags common to all LSPs
local flags = {
    debounce_text_changes = 150,
}

local on_attach = function(client, bufnr)
    -- map buffer local keybindings when the language server attaches
    if LSP_mappings then LSP_mappings(client, bufnr) end
    vim.wo.signcolumn = "yes"
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
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

-- Show a border around the hover window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "single",
    }
)

-- Only show the first line of diagnostics as virtual text
vim.diagnostic.config({virtual_text = {format = function(diag)
    return diag.message:match("[^\n]+")
end}})


-- Server configuration below

-- rust-analyzer
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,

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

    flags = flags,
}

-- Haskell Language Server
lspconfig.hls.setup {
    on_attach = on_attach,
    filetypes = { "haskell", "lhaskell", "cabal" },
}

-- TeXLab
lspconfig.texlab.setup {
    on_attach = on_attach,

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
                args = {"-g", "%l", "%p", "%f"},
            },
        },
    },

    flags = flags,
}

-- marksman (markdown)
lspconfig.marksman.setup {
    on_attach = on_attach,
    flags = flags,
}

-- lua-language-server
lspconfig.lua_ls.setup {
    on_attach = on_attach,
    flags = flags,
}

-- vscode-json-languageserver
lspconfig.jsonls.setup {
    on_attach = on_attach,
    flags = flags,
}
