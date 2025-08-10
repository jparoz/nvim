return { { "stevearc/conform.nvim",

opts = {
    formatters_by_ft = {
        rust = { "rustfmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
    },

    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
},

} }
