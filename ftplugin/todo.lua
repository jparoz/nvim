vim.bo.textwidth = 0
vim.wo.colorcolumn = "0"
vim.wo.linebreak = true
vim.go.showbreak = "  "
vim.wo.breakindent = true
vim.wo.breakindentopt = "shift:2,sbr"

keymap("n", "j", "gj", {buffer = true})
keymap("n", "k", "gk", {buffer = true})

function CheckUncheck()
    local matched = fn.getline("."):match("^%s*([-x]) ")
    if matched == "-" then
        cmd [[s/\- /x /]]
    elseif matched == "x" then
        cmd [[s/x /\- /]]
    end

    cmd [[nohlsearch]]
end

keymap("n", "<CR>", "<CMD>lua CheckUncheck()<CR>", {buffer = true, silent = true})
