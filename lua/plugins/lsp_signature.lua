return { { "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
        bind = true,
        floating_window = false,
        floating_window_off_x = 0,
        hint_prefix = {
            above = "↙ ",  -- when the hint is on the line above the current line
            current = "← ",  -- when the hint is on the same line
            below = "↖ "  -- when the hint is on the line below the current line
        },
        hint_scheme = "Virtual", -- highlight group
    },
    config = function(_, opt) require'lsp_signature'.setup(opt) end
} }
