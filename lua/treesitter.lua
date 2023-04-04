require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
        disable = {"tex"}, -- languages to disable go here
        additional_vim_regex_highlighting = false,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,

            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["am"] = "@class.outer",
                ["im"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true,

            goto_next_start = {
                ["]m"] = "@class.outer",
                ["]f"] = "@function.outer",
                ["]["] = "@function.outer",
            },
            goto_next_end = {
                ["]M"] = "@class.outer",
                ["]F"] = "@function.outer",
                ["]]"] = "@function.outer",
            },
            goto_previous_start = {
                ["[m"] = "@class.outer",
                ["[f"] = "@function.outer",
                ["[["] = "@function.outer",
            },
            goto_previous_end = {
                ["[M"] = "@class.outer",
                ["[F"] = "@function.outer",
                ["[]"] = "@function.outer",
            },
        },

        swap = {
            enable = true,
            swap_next = {
                ["<Leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<Leader>A"] = "@parameter.inner",
            },
        },
    },
}
