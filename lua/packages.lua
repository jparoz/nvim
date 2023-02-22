local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require "paq" {
    -- Package manager manages itself
    "savq/paq-nvim",

    -- General/smallish Vim-type upgrades
    "junegunn/vim-slash",
    "justinmk/vim-sneak",
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "tpope/vim-repeat",
    "tpope/vim-commentary",
    "tpope/vim-speeddating",
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "Raimondi/delimitMate",
    "lifepillar/vim-mucomplete",
    "godlygeek/tabular",
    "itchyny/lightline.vim",
    "airblade/vim-rooter",
    "tjdevries/colorbuddy.nvim",
    "norcalli/nvim-colorizer.lua",
    "editorconfig/editorconfig-vim",
    "airblade/vim-gitgutter",

    -- Specific feature packages
    "neovim/nvim-lspconfig",

    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",

    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",

    "junegunn/fzf",

    "subnut/nvim-ghost.nvim", -- GhostText browser extension

    "lewis6991/impatient.nvim", -- caching for Neovim config

    -- "knubie/vim-kitty-navigator", -- move between vim windows and kitty windows
    "jparoz/vim-kitty-navigator", -- fork until knubie/vim-kitty-navigator#38 is merged

    -- Language-specific
    "rust-lang/rust.vim",
    "teal-language/vim-teal",
    "fladson/vim-kitty",

    "KeitaNakamura/tex-conceal.vim",
    "gi1242/vim-tex-syntax",
}
