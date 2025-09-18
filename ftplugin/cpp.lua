vim.bo.commentstring = "// %s"

vim.bo.textwidth = 100

vim.bo.errorformat = vim.fn.join({
    "%f:%l:%c:\\ %trror:\\ %m",
    "%f:%l:%c:\\ %tarning:\\ %m",
}, ",")
