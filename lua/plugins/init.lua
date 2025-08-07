-- This is for all the plugins which we just use the default settings.
return {
    -- Core (obvious improvements, or couldn't live without)
    "junegunn/vim-slash",
    "justinmk/vim-sneak",
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "tpope/vim-repeat",
    "tpope/vim-speeddating",

    -- Good (very useful function, but could be better designed or implemented)
    { "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                -- Set up key mappings
                local gs = require "gitsigns"
                vim.keymap.set("n", "]g", gs.next_hunk, {buffer = bufnr})
                vim.keymap.set("n", "[g", gs.prev_hunk, {buffer = bufnr})
            end,
        },
    },

    { "folke/todo-comments.nvim",
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
                keyword = "bg",
                after = "",
            },
            search = {
                pattern = [[\b(KEYWORDS)\b]],
            },
        },
        init = function(_plugin)
            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next todo comment" })

            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" })
        end,
    },

    -- Medium (could live without these, but nice to have sometimes)
    { "godlygeek/tabular", cmd = "Tabularize" },

    -- Language-specific
    { "rust-lang/rust.vim", ft = "rust" },
    { "teal-language/vim-teal", ft = "teal" },
    { "fladson/vim-kitty", ft = "kitty" },
    { "dart-lang/dart-vim-plugin",
        ft = "dart",
        init = function()
            vim.g.dart_format_on_save = true
        end,
    },
    { "akinsho/flutter-tools.nvim",
        ft = "dart",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            closing_tags = {
                highlight = "Virtual",
                prefix = "",
            },
        },
    },
    { "evanleck/vim-svelte", ft = "svelte" },
    { "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    { "KeitaNakamura/tex-conceal.vim", ft = "tex" },
    { "gi1242/vim-tex-syntax", ft = "tex" },
}
