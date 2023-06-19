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

--- Colorscheme
vim.cmd [[colorscheme seethru]]

-- If the lockfile has been updated (e.g. pulled from git)
-- since this machine was restored/updated,
-- restore from the lockfile.
lazy.restore()
