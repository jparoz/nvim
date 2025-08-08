local M = {}

-- Lazy.nvim config. See init.lua for where this is used
M.config = {
    -- Automatically check for plugin updates
    checker = {
        enabled = true,
        notify = false,
    },

    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "zipPlugin",
                "tohtml",
                "tutor",
                -- "netrwPlugin", -- @Todo: replace this with something lighter
            }
        }
    },

    dev = { path = "~/dev/projects" },

    ui = {
        border = "rounded",
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
    install = { colorscheme = { "seethru" } },
}

return M
