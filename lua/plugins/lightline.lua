return { { "itchyny/lightline.vim",

dependencies = { "tpope/vim-fugitive" },

init = function()

    -- Workaround to fix lightline being defocused on LSP goto-diagnostic
    do
        -- from https://github.com/neovim/neovim/pull/15981
        local util = require "vim.lsp.util"
        local orig = util.make_floating_popup_options
        ---@diagnostic disable-next-line: duplicate-set-field
        util.make_floating_popup_options = function(width, height, opts)
            local orig_opts = orig(width, height, opts)
            orig_opts.noautocmd = true
            return orig_opts
        end
    end

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
                {"readonly", "relativepath", "modified"},
                {"git", "quickfix", "treesitter" },
                -- closest to centre
            },
            right = {
                -- closest to right
                {"lineinfo"},
                {"percent"},
                {
                    -- "treesitter",
                    -- "synstack",
                    "filetype",
                },
                -- closest to centre
            },
        },
        inactive = {
            left = {
                { "relativepath" }
            },
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
            lazy = "LazyStatus",
        },
    }


    -- Treesitter-based information about current cursor position

    -- Helper: Gets the span of text between two nodes (including the nodes)
    local function nodes_text(first, last)
        -- If only one node passed, use it as first and last
        last = last or first

        local first_row, first_col = first:start()
        local last_row, last_col = last:end_()
        local lines = vim.api.nvim_buf_get_text(
        0, -- current buffer
        first_row, first_col,
        last_row, last_col,
        {}) -- opts are required but currently unused
        return table.concat(lines, "\n")
    end

    function TreesitterStatus()
        local statusline = require("nvim-treesitter.statusline").statusline

        -- This is the available width we have for this component.
        -- Note that this is pretty brittle,
        -- and is likely to get out of sync with the config;
        -- but it's accurate as of [date of this comment's commit].
        local width = vim.fn.winwidth(0)
                    - #vim.fn["lightline#mode"]() - 2
                    - #vim.fn.expand("%") - 2
                    - (vim.opt.modified:get() and 4 or 0)
                    - #vim.fn.GitStatusline() - 2
                    - 2 -- for divider of this treesitter component
                    - #vim.bo.ft - 3 -- ft has an extra space to the left
                    - 6 -- percent
                    - #tostring(vim.api.nvim_buf_line_count(0)) -- line count
                    - #tostring(#vim.api.nvim_get_current_line()) -- column count
                    - 3 -- colon and spacing, i.e.: [ line:col ]
                    - 1 -- not 100% sure where this comes from

        if width < 5 then return "" end

        -- Generate the statusline string based on the file type
        local filetype = vim.opt.filetype:get()

        if filetype == "lua" then
            local opts = {}

            -- Note: don't ask me why subtract 5,
            -- it's because nvim-treesitter is silly
            opts.indicator_size = width-5
            opts.type_patterns = {"function_declaration"}

            -- Only include the function name and parameters
            opts.transform_fn = function(_line, node)
                return nodes_text(node, node:field("parameters")[1])
            end

            return statusline(opts)

        elseif filetype == "rust" then
            -- For Rust,
            -- we want something more complex than is easy to support
            -- with nvim-treesitter.statusline();
            -- so we'll manually walk the treesitter tree.

            local s = TreesitterStatusRust()

            if #s > width then
                -- truncate with ...
                s = s:sub(1, width-3) .. "..."
            end

            return s

        else
            -- Default
            -- Note: don't ask me why subtract 5,
            -- it's because nvim-treesitter is silly
            return statusline({indicator_size = width-5})
        end
    end

    utils.lua2vim("TreesitterStatus")

    local function goRustTS(node)
        -- Find the top-level item scope
        -- (e.g.
        -- struct/enum/trait declaration,
        -- function definition,
        -- impl block)
        local nodes = {}
        local current = node
        while current do
            table.insert(nodes, 1, current)
            current = current:parent()
        end

        -- Note: nodes[1] will always have node:type() == "source_file"
        if (not nodes[2])
            or (nodes[2]:extra())
            or (nodes[2]:missing()) then
            -- We're not inside any item
            return ""

        elseif nodes[2]:type() == "function_item" then
            -- Top-level (free) function
            local fn = nodes[2]

            -- If no return type (i.e. implicit -> ()),
            -- the text should end with the parameters;
            -- otherwise should end with return type.
            local return_type = fn:field("return_type")[1]
            local parameters = fn:field("parameters")[1]

            return nodes_text(fn, return_type or parameters)

        elseif nodes[2]:type() == "struct_item" then
            -- Struct definition
            local struct = nodes[2]
            return nodes_text(struct, struct:field("name")[1])

        elseif nodes[2]:type() == "enum_item" then
            -- Enum definition
            local enum = nodes[2]
            local enum_text = nodes_text(enum, enum:field("name")[1])

            local variant = nodes[4]

            if variant and variant:type() == "enum_variant" then
                -- We're inside a variant
                local variant_text = nodes_text(variant:field("name")[1])
                return enum_text .. "::" .. variant_text
            else
                -- Not in a variant, so just put "enum Type"
                return enum_text
            end

        elseif nodes[2]:type() == "impl_item" then
            -- Impl block
            local impl = nodes[2]

            local fn = nodes[4]

            if fn and fn:type() == "function_item" then
                -- We're inside an impl fn block, so put:
                -- pub fn ImplType::func_name(params) -> Ret

                -- prefix: pub fn
                local prefix = "fn "
                local vis = fn:child(0)
                if vis and vis:type() == "visibility_modifier" then
                    prefix = nodes_text(vis) .. " fn "
                end

                -- typ:
                -- Type in:               impl Type { }
                -- <Type as Trait> in:    impl Trait for Type { }
                local typ = nodes_text(impl:field("type")[1])
                local trait = impl:field("trait")[1]
                if trait then
                    local trait_text = nodes_text(trait)
                    typ = "<" .. typ .. " as " .. trait_text .. ">"
                end

                -- fn_text: foo(self, etc: Typ) -> Ret
                local name = fn:field("name")[1]
                local return_type = fn:field("return_type")[1]
                local parameters = fn:field("parameters")[1]
                local fn_text = nodes_text(name, return_type or parameters)

                return prefix .. typ .. "::" .. fn_text
            else
                -- Not in a fn, so just put "impl Type"
                return nodes_text(impl, impl:field("type")[1])
            end

        elseif nodes[2]:type() == "attribute_item" then
            -- It's a #[attr], so go forwards to the next item.
            -- Note that this type doesn't include #![attrs].
            return goRustTS(nodes[2]:next_sibling())

        else
            return ""

        end
    end

    function TreesitterStatusRust()
        return goRustTS(vim.treesitter.get_node())
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

        local cmd = "cd '" .. work .. "';" ..
                    "git diff origin/" .. branch .. "..HEAD --name-status"
        local res = vim.fn.system(cmd)
        if vim.v.shell_error > 0 then
            -- remote probably didn't have a matching branch
            return
        end
        GitCache[dir].diff = res
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

    function LazyStatus()
        local ls = require("lazy.status")
        if ls.has_updates() then
            return ls.updates()
        else
            return ""
        end
    end
    utils.lua2vim("LazyStatus")
end,

} }
