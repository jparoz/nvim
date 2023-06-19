local M = {}

-- If the lockfile has been updated (e.g. pulled from git)
-- since this machine was restored/updated,
-- restore from the lockfile.
M.restore = function()
    local config_path = vim.fn.stdpath("config")
    local lockfile_path = config_path .. "/lazy-lock.json"
    local restored_path = config_path .. "/.lazy-lock.restored"

    local need_restore = false

    -- Create the sentinal file if it doesn't exist
    if vim.fn.filereadable(restored_path) == 0 then
        vim.fn.system { "touch", restored_path }
        need_restore = true
    else
        local modified = vim.loop.fs_stat(lockfile_path).mtime.sec
        local restored = vim.loop.fs_stat(restored_path).mtime.sec

        -- Add a minute of leeway
        need_restore = (modified > restored+60)
    end

    if need_restore then
        vim.notify(
            "Lazy lockfile updated; restoring.",
            vim.log.levels.INFO)

        require("lazy").restore{show=false}

        -- Touch the file .lazy-lock.restored to mark the time.
        vim.fn.system { "touch", restored_path }
    end
end

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
