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
require("colorbuddy").colorscheme("frilless", false, {disable_defaults = true})

if has "macunix" then
    if vim.fn.system("scutil --get ComputerName") == "Jesse’s MacBook Air\n" then
        -- computer-specific stuff
        if has "gui_vimr" then
            vim.cmd "cd dev/projects"
        end
    end
end
