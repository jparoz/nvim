local cmd = vim.cmd
local opt = vim.opt
local g = vim.g

opt.textwidth = 80
opt.colorcolumn = "+1"

opt.equalalways = false

opt.undofile = true

opt.number = true
opt.scrolloff = 2

opt.showmode = false

opt.tabstop = 4
opt.shiftwidth=4
opt.shiftround = true
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true

opt.list = true
opt.listchars = {
    tab = "· ",
    trail = "·",
    nbsp = "·",
    extends = ">",
    precedes = "<",
}

opt.splitbelow = true
opt.splitright = true

opt.ignorecase = true
opt.smartcase = true

opt.foldmethod = "marker"

-- Lightline
function TreesitterStatus()
    local width = vim.fn.winwidth(0) - #vim.fn.expand("%:p:t") - #vim.bo.ft - 33
    return vim.fn["nvim_treesitter#statusline"](width)
end

cmd [[
function! TreesitterStatus()
    return luaeval("TreesitterStatus()")
endfunc
]]

g.lightline = {
    colorscheme = "jellybeans",
    active = {
        right = { { "lineinfo" }, { "percent" }, { "treesitter", "filetype" } }
        -- right = { { "lineinfo" }, { "percent" }, { "synstack", "filetype" } }
    },
    inactive = {
        right = { { "lineinfo" }, { "percent" } }
    },
    component_function = {
        treesitter = "TreesitterStatus",
        synstack = "SynStack",
    },
}

-- delimitMate
g.delimitMate_matchpairs = "(:),[:],{:}"
g.delimitMate_quotes = ""
g.delimitMate_expand_cr = 1

-- Rooter
g.rooter_cd_cmd = "lcd"
g.rooter_resolve_links = 1

-- Telescope
require("telescope").setup {
    defaults = {
        layout_config = {
            horizontal = {
                preview_width = 0.5,
            },
        },
    },
}

-- nvim-colorizer
opt.termguicolors = true
require("colorizer").setup()
