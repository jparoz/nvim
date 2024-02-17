return { { "tpope/vim-projectionist",

init = function()
    vim.g.projectionist_heuristics = {
        ["Templates/*/index.php"] = {
            ["Templates/*/index.php"] = { type = "php", related = {
                "Templates/{}/update.js",
                "Templates/{}/style.css",
                "Templates/{}/info.txt",
                "Templates/{}/info.json",
            } },
            ["Templates/*/update.js"] = { type = "js", related = {
                "Templates/{}/index.php",
                "Templates/{}/style.css",
                "Templates/{}/info.txt",
                "Templates/{}/info.json",
            } },
            ["Templates/*/style.css"] = { type = "css", related = {
                "Templates/{}/index.php",
                "Templates/{}/update.js",
                "Templates/{}/info.txt",
                "Templates/{}/info.json",
            } },
            ["Templates/*/info.txt"] = { type = "txt", related = {
                "Templates/{}/index.php",
                "Templates/{}/update.js",
                "Templates/{}/style.css",
                "Templates/{}/info.json",
            } },
            ["Templates/*/info.json"] = { type = "json", related = {
                "Templates/{}/index.php",
                "Templates/{}/update.js",
                "Templates/{}/style.css",
                "Templates/{}/info.txt",
            } },

            ["schemas/*/v1.schema.json"] = {
                type = "schema",
                alternate = "schemas/{}/instance.json",
            },
            ["schemas/*/instance.json"] = {
                type = "instance",
                alternate = "schemas/{}/v1.schema.json",
            },
        }
    }
end,

} }
