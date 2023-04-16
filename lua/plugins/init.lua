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
    "airblade/vim-gitgutter",

    -- Medium (could live without these, but nice to have sometimes)
    { "godlygeek/tabular", cmd = "Tabularize" },
    { "subnut/nvim-ghost.nvim", module = false }, -- GhostText browser extension

    -- Language-specific
    { "rust-lang/rust.vim", ft = "rust" },
    { "teal-language/vim-teal", ft = "teal" },
    { "fladson/vim-kitty", ft = "kitty" },
    { "evanleck/vim-svelte", ft = "svelte" },
    { "iamcco/markdown-preview.nvim", ft = "markdown" },
    { "KeitaNakamura/tex-conceal.vim", ft = "tex" },
    { "gi1242/vim-tex-syntax", ft = "tex" },
}
