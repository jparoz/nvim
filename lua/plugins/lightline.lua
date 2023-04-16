return { { "itchyny/lightline.vim",

dependencies = { "tpope/vim-fugitive" },

init = function()
    local utils = require "utils"

    vim.g.lightline = {
        colorscheme = "seethru",
        mode_map = {
            n        = 'normal',
            i        = 'insert',
            R        = 'replace',
            v        = 'visual',
            V        = 'v-line',
            -- <C-v>
            ["\x16"] = 'v-block',
            c        = 'command',
            s        = 'select',
            S        = 's-line',
            -- <C-s>
            ["\x13"] = 's-block',
            t        = 'terminal',
        },
        active = {
            left = {
                -- closest to left
                {"mode", "paste"},
                {"readonly", "filename", "modified"},
                {"git", "quickfix"},
                -- closest to centre
            },
            right = {
                -- closest to right
                {"lineinfo"},
                {"percent"},
                -- {"treesitter", "filetype"},
                -- {"synstack", "filetype"},
                {"filetype"},
                -- closest to centre
            },
        },
        inactive = {
            right = {
                { "lineinfo" },
                { "percent" },
            },
        },
        component_function = {
            treesitter = "TreesitterStatus",
            synstack = "SynStack",
            git = "GitStatusline",
            quickfix = "QFStatusline",
        },
        component = {
            filename = "%f",
        },
    }

    function TreesitterStatus()
        local width = vim.fn.winwidth(0) - #vim.fn.expand("%:p:t") - #vim.bo.ft - 33
        local res = vim.fn["nvim_treesitter#statusline"](width)
        if res == vim.NIL then
            return ""
        else
            return res
        end
    end

    utils.lua2vim("TreesitterStatus")

    GitCache = {}

    function UpdateGitStatusline(dir)
        dir = dir or vim.fn.FugitiveGitDir()
        if not GitCache[dir] then GitCache[dir] = {diff = ""} end

        local work = vim.fn.FugitiveWorkTree()

        local handle

        handle = io.popen("cd '" .. work .. "'; git status --porcelain 2>/dev/null")
        if not handle then return end
        GitCache[dir].status = handle:read("a")
        handle:close()

        -- Check if we have a remote
        vim.fn.system("git config remote.origin.url")
        if vim.v.shell_error > 0 then
            -- there is no origin
            return
        end

        -- Get the name of the current branch
        local branch = vim.fn["fugitive#Head"]()

        handle = io.popen("cd '" .. work .. "'; git diff origin/"..branch.."..HEAD --name-status")
        if not handle then return end
        GitCache[dir].diff = handle:read("a")
        handle:close()
    end

    function GitStatusline()
        local head = vim.fn.FugitiveHead()
        if head == "" then return "" end

        local dir = vim.fn.FugitiveGitDir()
        if not GitCache[dir] then
            UpdateGitStatusline(dir)
        end

        local dirty = GitCache[dir].status:find("^ [MADRCU]")
        local need_push = GitCache[dir].diff:find(".")

        return head .. (dirty and " *" or "") .. (need_push and " ↑" or "")
    end
    utils.lua2vim("GitStatusline")

    vim.cmd [[
    augroup UpdateGitStatusline
    autocmd!
    autocmd BufWritePost * call v:lua.UpdateGitStatusline()
    autocmd User FugitiveChanged call v:lua.UpdateGitStatusline()
    augroup END
    ]]

    function QFStatusline()
        local counts = {}

        for _, entry in ipairs(vim.fn.getqflist()) do
            if not counts[entry.type] then
                counts[entry.type] = 0
            end
            counts[entry.type] = counts[entry.type] + 1
        end

        local list = {}

        for key, count in pairs(counts) do
            table.insert(list, {key, count})
        end

        vim.fn.sort(list, function(a, b)
            if a[1] < b[1] then
                return -1
            elseif a[1] > b[1] then
                return 1
            else
                return 0
            end
        end)

        local strings = {}
        for _, pair in ipairs(list) do
            if pair[1] ~= "" then
                table.insert(strings, pair[1] .. ": " .. pair[2])
            end
        end

        return vim.fn.join(strings, ", ")
    end
    utils.lua2vim("QFStatusline")
end,

} }
