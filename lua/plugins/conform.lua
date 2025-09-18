return { { "stevearc/conform.nvim",

opts = {
    formatters_by_ft = {
        rust = { "rustfmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        python = { "ruff_format", "ruff_organize_imports" },
        cpp = { "clang-format" },
    },

    format_on_save = {
        timeout_ms = 500,
    },
},

} }
