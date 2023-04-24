-- Trouble.nvim
return { { "folke/trouble.nvim",

opts = {
    icons = false,
    padding = false,
    fold_open = "▼",
    fold_closed = "►",
    indent_lines = false,
    use_diagnostic_signs = true,
},

cmd = {"Trouble", "TroubleToggle"},

keys = {
    { "<Leader>t", "<CMD>TroubleToggle<CR>" },
    { "<Leader>r", "<CMD>TroubleToggle lsp_references<CR>" },
},

} }
