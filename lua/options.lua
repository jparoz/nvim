vim.opt.mouse = "nvi"

vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"

vim.opt.number = true

vim.opt.equalalways = false

vim.opt.undofile = true

vim.opt.scrolloff = 2

vim.opt.showmode = false
vim.opt.showcmd = false

vim.opt.updatetime = 100

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.smarttab = true
vim.opt.autoindent = true

vim.opt.list = true
vim.opt.listchars = {
    tab = "⇥ ",
    trail = "·",
    nbsp = "·",
    extends = ">",
    precedes = "<",
}

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.foldmethod = "marker"

vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"

vim.opt.diffopt:append("linematch:60")

-- Border around floating windows e.g. LSP hover
vim.opt.winborder = "rounded"

-- Diagnostics
vim.diagnostic.config {
    underline = false,
}
