-- Trouble.nvim
return { { "folke/trouble.nvim",

opts = {
    icons = {},
    padding = false,
    fold_open = "▼",
    fold_closed = "►",
    indent_lines = false,
    use_diagnostic_signs = true,
},

cmd = {"Trouble", "TroubleToggle"},

keys = {
    { "<Leader>t", "<CMD>Trouble toggle<CR>" },
    { "<Leader>r", "<CMD>Trouble lsp_references toggle<CR>" },
},

} }
