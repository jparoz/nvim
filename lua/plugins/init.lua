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

    { "sindrets/diffview.nvim",
        opts = {
            use_icons = false,
        },
    },

    { "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
            "ray-x/lsp_signature.nvim",
        },
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
    { "gleam-lang/gleam.vim", ft = "gleam" },
    { "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    { "KeitaNakamura/tex-conceal.vim", ft = "tex" },
    { "gi1242/vim-tex-syntax", ft = "tex" },
}
