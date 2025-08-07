return { { "luukvbaal/statuscol.nvim",

dependencies = { "lewis6991/gitsigns.nvim" },

config = function()
    local builtin = require("statuscol.builtin")

    require("statuscol").setup {
        segments = {
            { -- Git signs
                sign = {
                    namespace = { "gitsigns" },
                    colwidth = 2,
                },
                click = "v:lua.ScSa",
            },

            { -- Diagnostics
                sign = {
                    namespace = { "diagnostic" },
                    colwidth = 2,
                },
                click = "v:lua.ScSa",
            },

            { -- All others
                sign = {
                    name = { ".*" },
                    maxwidth = 2,
                    colwidth = 1,
                    auto = true,
                    wrap = true,
                },
                click = "v:lua.ScSa",
            },

            -- Line numbers and a single space separator
            { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
            { text = { " " }, condition = { builtin.not_empty } },
        },
    }
end,

} }
