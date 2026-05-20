return {
    dir = vim.fn.stdpath("config"),
    name = "smart_split",
    config = function()
        require("smart_split").setup {
            blocklist = {
                filetype = {},
                buftype = {},
                bufname = {},
            },
            ignore = {
                commands = {
                    "^%s*sp%s*.*$",
                    "^%s*split%s*.*$",
                    "^%s*vs%s*.*$",
                    "^%s*vsplit%s*.*$",
                    "^%s*vertical%s+.*$",
                    "^%s*vert%l*%s+.*$",
                    "^%s*horizontal%s+.*$",
                    "^%s*hor%l*%s+.*$",
                },
            },
            heuristics = {
                min_vertical_width = 100,
                min_horizontal_height = 30,
                min_horizontal_width = 80,
                min_columns = 2,
                default_textwidth = 80,
                textwidth_mode = "visible_max",
                prefer_vertical_after_columns = 2,
                wide_ratio = 1.8,
            },
            move = "respect_options",
            log = {
                level = "off",
                file = vim.fn.stdpath("state") .. "/smart_split.log",
                notify = false,
            },
        }
    end,
}
