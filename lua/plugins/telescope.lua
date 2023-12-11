return {
{ "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },

    opts = {
        extensions = {
            file_browser = {
                dir_icon = " ",
                hijack_netrw = true,
            },
        },
    },

    cmd = "Telescope",

    keys = {
        { "-",         function() require("telescope").extensions.file_browser.file_browser() end },
        { "<Leader>f", function() require("telescope.builtin").find_files() end },
        { "<Leader>g", function() require("telescope.builtin").live_grep() end },
        { "<Leader>h", function() require("telescope.builtin").help_tags() end },
        { "<Leader>b", function() require("telescope.builtin").buffers() end },
        { "<Leader>/", function() require("telescope.builtin").lsp_workspace_symbols() end },
        { "gd",        function() require("telescope.builtin").lsp_definitions() end },
        { "gi",        function() require("telescope.builtin").lsp_implementations() end },
        { "gr",        function() require("telescope.builtin").lsp_references() end },
    },
},

}
