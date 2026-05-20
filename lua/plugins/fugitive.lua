return { "tpope/vim-rhubarb", { "tpope/vim-fugitive",

init = function()
    -- open Fugitive status window
    vim.keymap.set("n", "-", "<CMD>below Git<CR>")
end,

} }
