require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
        disable = {"tex"}, -- languages to disable go here
        additional_vim_regex_highlighting = false,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
        },
        move = {
            enable = true,
            set_jumps = true,
        },
    },
}
