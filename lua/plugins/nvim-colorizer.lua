return { { "norcalli/nvim-colorizer.lua",

-- Contains filetypes to enable the colorizer
opts = {
    "markdown",
    "text",
    "css",
    "javascript",
    "html",
},

init = function()
    vim.opt.termguicolors = true
end,

} }
