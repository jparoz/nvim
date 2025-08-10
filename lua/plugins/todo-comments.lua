return { { "folke/todo-comments.nvim",

dependencies = { "nvim-lua/plenary.nvim" },

opts = {
    signs = false,
    keywords = {
        TODO = { icon = "●", color = "hint" },
        NOTE = { icon = "ℹ", color = "hint", alt = { "INFO" } },
        PERF = { icon = "●", color = "hint", alt = { "OPTIMIZE" } },
        FIX = {
            icon = "●",
            color = "warning",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "CLEANUP" },
        },
        WARN = { icon = "●", color = "warning", alt = { "WARNING" } },
        HACK = { icon = "●", color = "warning", alt = { "XXX" } },
        TEST = {
            icon = "ℹ",
            color = "info",
            alt = { "TESTING", "PASSED", "FAILED" }
        },
    },
    highlight = {
        pattern = [[.*<(KEYWORDS)\s*:?]],
        keyword = "fg",
        after = "",
    },
    search = {
        pattern = [[\b(KEYWORDS)\b]],
    },

    gui_style = { fg = "bold" },
},

init = function(_plugin)
    vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
    end, { desc = "Previous todo comment" })
end,

} }
