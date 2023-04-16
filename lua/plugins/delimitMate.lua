return { { "Raimondi/delimitMate",

init = function()
    vim.g.delimitMate_matchpairs = "(:),[:],{:}"
    vim.g.delimitMate_quotes = ""
    vim.g.delimitMate_expand_cr = 1
end,

} }
