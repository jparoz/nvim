return { { "rcarriga/nvim-notify",

opts = {
    render = "compact",
    stages = "fade",
    timeout = 3000,
    icons = {
        DEBUG = "➤",
        ERROR = "●",
        INFO = "ℹ",
        TRACE = "✎",
        WARN = "○"
    },
},
init = function()
    vim.opt.termguicolors = true
    vim.notify = require("notify")
end,

} }
