vim.cmd "filetype plugin on"
vim.cmd "syntax on"

vim.g.mapleader = " "

local has = require("utils").has

require "packages"

require "lsp"
require "fzf"
require "treesitter"

require "options"

require "commands"

require "mappings"

require "autocommands"

--- Colorscheme
vim.cmd [[colorscheme seethru]]
