return { { "tpope/vim-commentary",

init = function()
    vim.keymap.set({"o", "n", "x"}, "<BSlash>", "<Plug>Commentary", {remap = true})
    vim.keymap.set("n", "<BSlash><BSlash>", "<Plug>CommentaryLine", {remap = true})
end,

} }
