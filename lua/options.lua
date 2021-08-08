local opt = vim.opt
local g = vim.g
local utils = require "utils"

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
    local res = vim.fn["nvim_treesitter#statusline"](width)
    if res == vim.NIL then
        return ""
    else
        return res
    end
end
utils.lua2vim("TreesitterStatus")


GitCache = {}

function UpdateGitStatusline(dir)
    dir = dir or vim.fn.FugitiveGitDir()
    if not GitCache[dir] then GitCache[dir] = {} end

    local work = vim.fn.FugitiveWorkTree()

    local handle

    handle = io.popen("cd " .. work .. ";git status --porcelain")
    GitCache[dir].status = handle:read("a")
    handle:close()

    handle = io.popen("cd " .. work .. ";git diff origin/master..HEAD --name-status")
    GitCache[dir].diff = handle:read("a")
    handle:close()
end

function GitStatusline()
    local head = vim.fn.FugitiveHead()
    if head == "" then return "" end

    local dir = vim.fn.FugitiveGitDir()
    if not GitCache[dir] then
        UpdateGitStatusline(dir)
    end

    local dirty = GitCache[dir].status:find("^ [MADRCU]")
    local need_push = GitCache[dir].diff:find(".")

    return head .. (dirty and " *" or "") .. (need_push and " ↑" or "")
end
utils.lua2vim("GitStatusline")

vim.cmd [[
augroup UpdateGitStatusline
  autocmd!
  autocmd BufWritePost * call v:lua.UpdateGitStatusline()
  autocmd User FugitiveChanged call v:lua.UpdateGitStatusline()
augroup END
]]

g.lightline = {
    colorscheme = "jellybeans",
    active = {
        left = {
            -- closest to left
            {"mode", "paste"},
            {"readonly", "filename", "modified"},
            {"git"},
            -- closest to centre
        },
        right = {
            -- closest to right
            {"lineinfo"},
            {"percent"},
            -- {"treesitter", "filetype"},
            {"filetype"},
            -- closest to centre
        },
    },
    inactive = {
        right = {
            { "lineinfo" },
            { "percent" },
        },
    },
    component_function = {
        treesitter = "TreesitterStatus",
        synstack = "SynStack",
        git = "GitStatusline",
    },
}

-- delimitMate
g.delimitMate_matchpairs = "(:),[:],{:}"
g.delimitMate_quotes = ""
g.delimitMate_expand_cr = 1

-- Rooter
g.rooter_cd_cmd = "lcd"
g.rooter_resolve_links = 1

-- nvim-colorizer
opt.termguicolors = true
require("colorizer").setup()
