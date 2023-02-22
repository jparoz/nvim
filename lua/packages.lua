local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require "paq" {
    -- Package manager manages itself
    "savq/paq-nvim",

    -- Core (obvious improvements, or couldn't live without)
    "junegunn/vim-slash",
    "justinmk/vim-sneak",
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "tpope/vim-repeat",
    "tpope/vim-commentary",
    "tpope/vim-speeddating",
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "neovim/nvim-lspconfig",
    "itchyny/lightline.vim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "lewis6991/impatient.nvim", -- caching for Neovim config
    "junegunn/fzf",

    -- Good (very useful function, but could be better designed or implemented)
    "lifepillar/vim-mucomplete",
    "airblade/vim-rooter",
    "Raimondi/delimitMate",

    -- Medium (could live without these, but nice to have sometimes)
    "norcalli/nvim-colorizer.lua",
    "godlygeek/tabular",
    "airblade/vim-gitgutter",
    "subnut/nvim-ghost.nvim", -- GhostText browser extension

    -- Language-specific
    "rust-lang/rust.vim",
    "teal-language/vim-teal",
    "fladson/vim-kitty",
    "evanleck/vim-svelte",

    "KeitaNakamura/tex-conceal.vim",
    "gi1242/vim-tex-syntax",
}

require "impatient"
