local keymap = require("utils").keymap

vim.bo.textwidth = 999
vim.wo.linebreak = true
vim.go.showbreak = "  "
vim.wo.breakindent = true
vim.wo.breakindentopt = "shift:2,sbr"

keymap("n", "j", "gj", {buffer = true})
keymap("n", "k", "gk", {buffer = true})

function CheckUncheck()
    local matched = vim.fn.getline("."):match("^%s*([-x]) ")
    if matched == "-" then
        vim.cmd [[s/\- /x /]]
    elseif matched == "x" then
        vim.cmd [[s/x /\- /]]
    end

    vim.cmd [[nohlsearch]]
end

keymap("n", "<CR>", "<CMD>lua CheckUncheck()<CR>", {buffer = true, silent = true})
