local opt = vim.opt
local g = vim.g
local utils = require "utils"

-- disable some builtin vim plugins
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zipPlugin = 1
g.loaded_2html_plugin = 1

opt.mouse = "nvi"

opt.textwidth = 80
opt.colorcolumn = "+1"

opt.equalalways = false

opt.undofile = true

opt.number = true
opt.scrolloff = 2

opt.showmode = false
opt.showcmd = false

opt.updatetime = 100

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.shiftround = true
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

opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- Diagnostics
vim.diagnostic.config {
    underline = false,
}

-- mucomplete
g["mucomplete#chains"] = {
    default = {'omni', 'path', 'keyn', 'dict', 'uspl'},
    vim = {'path', 'cmd', 'keyn'},

    -- Having 'omni' and 'keyn' breaks the ordering for some reason.
    -- See https://github.com/lifepillar/vim-mucomplete/issues/180#issuecomment-939507716
    rust = {'omni', 'path', 'dict', 'uspl'},
}

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
    if not GitCache[dir] then GitCache[dir] = {diff = ""} end

    local work = vim.fn.FugitiveWorkTree()

    local handle

    handle = io.popen("cd " .. work .. ";git status --porcelain 2>/dev/null")
    GitCache[dir].status = handle:read("a")
    handle:close()

    -- Check if we have a remote
    if os.execute("git config remote.origin.url") > 0 then
        -- there is no origin
        return
    end

    -- Get the name of the current branch
    local branch = vim.fn["fugitive#Head"]()

    handle = io.popen("cd " .. work .. ";git diff origin/"..branch.."..HEAD --name-status")
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

function QFStatusline()
    local counts = {}

    for _, entry in ipairs(vim.fn.getqflist()) do
        if not counts[entry.type] then
            counts[entry.type] = 0
        end
        counts[entry.type] = counts[entry.type] + 1
    end

    local list = {}

    for key, count in pairs(counts) do
        table.insert(list, {key, count})
    end

    vim.fn.sort(list, function(a, b)
        if a[1] < b[1] then
            return -1
        elseif a[1] > b[1] then
            return 1
        else
            return 0
        end
    end)

    local strings = {}
    for _, pair in ipairs(list) do
        if pair[1] ~= "" then
            table.insert(strings, pair[1] .. ": " .. pair[2])
        end
    end

    return vim.fn.join(strings, ", ")
end
utils.lua2vim("QFStatusline")

g.lightline = {
    colorscheme = "seethru",
    mode_map = {
        n        = 'normal',
        i        = 'insert',
        R        = 'replace',
        v        = 'visual',
        V        = 'v-line',
        -- <C-v>
        ["\x16"] = 'v-block',
        c        = 'command',
        s        = 'select',
        S        = 's-line',
        -- <C-s>
        ["\x13"] = 's-block',
        t        = 'terminal',
    },
    active = {
        left = {
            -- closest to left
            {"mode", "paste"},
            {"readonly", "filename", "modified"},
            {"git", "quickfix"},
            -- closest to centre
        },
        right = {
            -- closest to right
            {"lineinfo"},
            {"percent"},
            -- {"treesitter", "filetype"},
            -- {"synstack", "filetype"},
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
        quickfix = "QFStatusline",
    },
    component = {
        filename = "%f",
    },
}

-- delimitMate
g.delimitMate_matchpairs = "(:),[:],{:}"
g.delimitMate_quotes = ""
g.delimitMate_expand_cr = 1

-- Rooter
g.rooter_cd_cmd = "lcd"
g.rooter_resolve_links = 1
g.rooter_buftypes = {""} -- don't trigger on nofile, nowrite, or acwrite
g.rooter_patterns = {
    -- Defaults
    ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json",

    -- My LaTeX build directory convention
    "output/*.log",

    -- Stack/hpack config file
    "package.yaml",
}

-- nvim-colorizer
-- opt.termguicolors = true
-- require("colorizer").setup()

-- Vim-Markdown
g.vim_markdown_folding_disabled = 1
g.vim_markdown_no_default_key_mappings = 1

-- vim-kitty-navigator
g.kitty_navigator_password = "vim-kitty-navigator"
