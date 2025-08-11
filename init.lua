vim.g.mapleader = " "

-- Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require "lazy_config"
require("lazy").setup("plugins", lazy.config)

require "options"
require "commands"
require "mappings"
require "autocommands"
require "lsp"

-- This file should only run in neovide
if vim.g.neovide then
    require "neovide"
end

--- Colorscheme
vim.cmd [[colorscheme seethru]]
