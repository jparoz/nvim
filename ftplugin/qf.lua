function QFFoldText()
    return vim.fn.getline(vim.v.foldstart)
end

function QFFoldExpr()
    local current_found = vim.fn.getline(vim.v.lnum):find("^[^|]")
    if current_found then return ">1" end -- start a new fold

    local next_found = vim.fn.getline(vim.v.lnum + 1):find("^[^|]")
    if next_found then return "<1" end -- end the fold

    return "1" -- else, this line is in the current fold
end

vim.wo.foldlevel = 0
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.QFFoldExpr()"
vim.wo.foldtext = "v:lua.QFFoldText()"
vim.wo.fillchars = "fold: "
vim.bo.textwidth = 0

vim.keymap.set("n", "=", "za", {buffer = true})
