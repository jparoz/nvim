return { { "tpope/vim-projectionist",

init = function()
    vim.g.projectionist_heuristics = {
        ["Templates/*/index.php"] = {
            ["Templates/*/index.php"] = { type = "php", related = {
                "Templates/{}/board.js",
                "Templates/{}/style.css",
                "Templates/{}/info.txt",
            } },
            ["Templates/*/board.js"] = { type = "js", related = {
                "Templates/{}/index.php",
                "Templates/{}/style.css",
                "Templates/{}/info.txt",
            } },
            ["Templates/*/style.css"] = { type = "css", related = {
                "Templates/{}/index.php",
                "Templates/{}/board.js",
                "Templates/{}/info.txt",
            } },
            ["Templates/*/info.txt"] = { type = "txt", related = {
                "Templates/{}/index.php",
                "Templates/{}/board.js",
                "Templates/{}/style.css",
            } },
        }
    }
end,

} }
