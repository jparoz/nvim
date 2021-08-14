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
    "Raimondi/delimitMate",
    "ervandew/supertab",
    "godlygeek/tabular",
    "itchyny/lightline.vim",
    "airblade/vim-rooter",
    "tjdevries/colorbuddy.nvim",
    "norcalli/nvim-colorizer.lua",
    "editorconfig/editorconfig-vim",

    -- Specific feature packages
    "neovim/nvim-lspconfig",

    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",

    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",

    "junegunn/fzf",

    -- Language-specific
    "rust-lang/rust.vim",
    "teal-language/vim-teal",
}
