return { { "airblade/vim-rooter",

init = function()
    vim.g.rooter_cd_cmd = "lcd"
    vim.g.rooter_resolve_links = 1
    vim.g.rooter_buftypes = {""} -- don't trigger on nofile, nowrite, or acwrite
    vim.g.rooter_patterns = {
        -- Defaults
        ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json",

        -- My LaTeX build directory convention
        "output/*.log",

        -- Stack/hpack config file
        "package.yaml",
    }
end,

} }
