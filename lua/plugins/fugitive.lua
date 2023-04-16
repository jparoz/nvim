return { "tpope/vim-rhubarb", { "tpope/vim-fugitive",

init = function()
    -- open Fugitive status window
    vim.keymap.set("n", "<Leader>-", "<CMD>below Git<CR>")
end,

} }
