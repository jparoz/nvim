return {
    {
        "nvim-treesitter/nvim-treesitter",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = { "lua", "rust", "markdown" },

            highlight = {
                enable = true,
                disable = { "tex" }, -- languages to disable go here
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
        },
        init = function()
            local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
            parser_config.markdown_inline.install_info = {
                url = "~/dev/projects/tree-sitter-markdown",
                location = "tree-sitter-markdown-inline",
                files = { "src/parser.c", "src/scanner.c" },
            }
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
}
