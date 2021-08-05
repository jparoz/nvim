local opt = vim.opt
local g = vim.g
local utils = require "utils"

opt.textwidth = 80
opt.colorcolumn = "+1"

opt.equalalways = false

opt.undofile = true

opt.number = true
opt.scrolloff = 2

opt.showmode = false

opt.tabstop = 4
opt.shiftwidth=4
opt.shiftround = true
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true

opt.list = true
opt.listchars = {
    tab = "· ",
    trail = "·",
    nbsp = "·",
    extends = ">",
    precedes = "<",
}

opt.splitbelow = true
opt.splitright = true

opt.ignorecase = true
opt.smartcase = true

opt.foldmethod = "marker"

-- Lightline
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
    if not GitCache[dir] then GitCache[dir] = {} end

    local work = vim.fn.FugitiveWorkTree()

    local handle

    handle = io.popen("cd " .. work .. ";git status --porcelain")
    GitCache[dir].status = handle:read("a")
    handle:close()

    handle = io.popen("cd " .. work .. ";git diff origin/master..HEAD --name-status")
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

g.lightline = {
    colorscheme = "jellybeans",
    active = {
        left = {
            -- closest to left
            {"mode", "paste"},
            {"readonly", "filename", "modified"},
            {"git"},
            -- closest to centre
        },
        right = {
            -- closest to right
            {"lineinfo"},
            {"percent"},
            -- {"treesitter", "filetype"},
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
    },
}

-- delimitMate
g.delimitMate_matchpairs = "(:),[:],{:}"
g.delimitMate_quotes = ""
g.delimitMate_expand_cr = 1

-- Rooter
g.rooter_cd_cmd = "lcd"
g.rooter_resolve_links = 1

-- nvim-colorizer
opt.termguicolors = true
require("colorizer").setup()


-- FZF
g.fzf_layout = {
    window = {
        width = 0.8,
        height = 0.9,
    },
}

FZF = setmetatable({}, {__call = function(_, spec)
    spec = spec or {}
    spec.options = spec.options or {}
    local sinklist = spec.sinklist

    if spec.prompt then
        vim.list_extend(spec.options, { "--prompt", spec.prompt })
    end

    if spec.preview then
        vim.list_extend(spec.options, { "--preview", spec.preview })
    end

    if spec.expect then
        table.insert(spec.options, "--expect")
        table.insert(spec.options, table.concat(spec.expect, ","))
    end

    if spec.binds then
        table.insert(spec.options, "--bind")
        table.insert(spec.options, table.concat(spec.binds, ","))
    end

    if spec.print_query then
        table.insert(spec.options, "--print-query")
    end

    spec = vim.fn["fzf#wrap"](spec)

    spec.sink = nil
    spec["sink*"] = nil
    spec.sinklist = sinklist

    vim.fn["fzf#run"](spec)
end})

function FZF.file_browser(spec)
    spec = spec or {}

    FZF.fd = {}
    FZF.fd.cwd = vim.fn.getcwd()
    FZF.fd.searchOnly = spec.searchOnly

    local escape = function(s)
        return s:gsub('"', '\\"'):gsub("'", "\\'"):gsub("%$", "\\$")
    end

    local nvim_cb = function(cmd)
        return
            "nvim-cb -s " .. vim.v.servername ..
            ' -l "' .. escape(cmd) .. '"'
    end

    local nvim_eval = function(expr)
        return
            "nvim-cb -s " .. vim.v.servername ..
            " -l 'return " .. expr .. "'" ..
            " | source"
    end

    local fd = function(searchOnly)
        local s = "fd --follow"
        searchOnly = searchOnly or FZF.fd.searchOnly

        if searchOnly == "toggle" then
            FZF.fd.searchOnly = FZF.fd.searchOnly == "files" and "directories" or "files"
        elseif searchOnly == "any" then
            FZF.fd.searchOnly = nil
        end

        if FZF.fd.searchOnly == "files" then
            s = s .. " -t=f"
        elseif FZF.fd.searchOnly == "directories" then
            s = s .. " -t=d"
        end

        if FZF.fd.hidden then
            s = s .. " --hidden"
        end

        s = s .. " . " .. FZF.fd.cwd

        return s
    end
    FZF.fd.fd = fd

    FZF.fd.cd = function(path)
        if path == ".." then
            local matched = FZF.fd.cwd:match("^(.*)/[^/]+/?$")
            FZF.fd.cwd = matched == "" and "/" or matched or "/"
        elseif path == "~" then
            FZF.fd.cwd = os.getenv("HOME")
        else
            FZF.fd.cwd = path
        end
    end

    local cd = function(path)
        return nvim_cb("FZF.fd.cd " .. vim.inspect(path))
    end

    local toggle_hidden = nvim_cb[[FZF.fd.hidden = not FZF.fd.hidden]]

    spec = vim.tbl_extend("keep", spec or {}, {
        source = fd(),
        preview = "if test -d {}; env CLICOLOR_FORCE=1 ls -GA {}; else; cat {}; end",
        expect = {"ctrl-e"},
        print_query = true,
        binds = {
            "change:unbind(-,~,/,change)",
                 "-:reload("..nvim_eval[[FZF.fd.fd()]]..")+execute-silent("..cd("..")..")",
                 "~:reload("..nvim_eval[[FZF.fd.fd()]]..")+execute-silent("..cd("~" )..")",
                 "/:reload("..nvim_eval[[FZF.fd.fd()]]..")+execute-silent("..cd("/" )..")",
            "ctrl-f:reload("..nvim_eval[[FZF.fd.fd("toggle")]]..")",
            "ctrl-b:reload("..nvim_eval[[FZF.fd.fd("any")]]..")",
            "ctrl-d:reload("..nvim_eval[[FZF.fd.fd()]]..")+execute(rm -ir {})",
            "ctrl-h:reload("..nvim_eval[[FZF.fd.fd()]]..")+execute-silent("..toggle_hidden..")",
        }
    })

    spec.sinklist = function(list)
        printi(list)
        local query, command, line = unpack(list)

        if command == "ctrl-e" then
            if not line then
                vim.cmd("e " .. query)
            elseif vim.fn.filereadable(line) == 1 then
                vim.cmd("e " .. line)
            else
                print("bad stuff after ctrl-e, see options.lua")
            end
        else -- command == "enter" then
            if vim.fn.isdirectory(line) == 1 then
                vim.cmd("lcd " .. line)
            elseif vim.fn.filereadable(line) == 1 then
                vim.cmd("e " .. line)
            end
        end
    end

    FZF(spec)
end

function FZF.find_files()
    FZF.file_browser {
        searchOnly = "files",
    }
end

function FZF.live_grep()
    local saved_cmd = vim.env.FZF_DEFAULT_COMMAND
    local rg =
        "rg --column --line-number --no-heading --color=always --smart-case "
    vim.env.FZF_DEFAULT_COMMAND = rg .. "."

    FZF {
        prompt = "Rg> ",
        preview = "bat --color=always {1} --highlight-line {2}",
        window = {
            width = 100,
            height = 0.9,
        },

        sinklist = function(list)
            local command, line
            if #list == 1 then
                line = list[1]
            else
                command, line = unpack(list)
            end
            if not line then print("Command: " .. command) end

            local path, line_nr, col_nr = unpack(vim.split(line, ":", true))

            if vim.fn.filereadable(path) == 1 then
                vim.cmd("e " .. path ..
                    " | call cursor(" .. line_nr .. ", " .. col_nr .. ")")
            end
        end,

        binds = {
            "change:reload:sleep 0.1; " .. rg .. "{q} . || true",
        },

        options = {
            "--ansi",
            "--disabled",
            "--delimiter", ":",
            "--preview-window", "up,60%,border-bottom,+{2}+3/3,~3",
        },
    }

    vim.env.FZF_DEFAULT_COMMAND = saved_cmd
end

function FZF.help_tags()
    -- lifted directly from telescope.nvim: builtin.help_tags()
    local tag_files = {}

    local help_files = {}
    local all_files = vim.fn.globpath(vim.o.runtimepath, "doc/*", 1, 1)
    for _, fullpath in ipairs(all_files) do
        local file = fullpath:match("[^/]*$")
        if file == "tags" or file:match("^tags%-en$") then
            table.insert(tag_files, fullpath)
        elseif file:match("^tags%-..$") then
            -- do nothing, because we ignore other languages
        else
            help_files[file] = fullpath
        end
    end
    help_files["tags"] = vim.env.VIMRUNTIME .. "/doc/tags"

    local tags = {}
    for _, path in ipairs(tag_files) do
        for line in io.lines(path) do
            local fields = vim.split(line, "\t", true)
            if not line:match "^!_TAG_" then
                if #fields == 3 then
                    local name = fields[1]
                    local filename = help_files[fields[2]]
                    local tag_cmd = fields[3]
                    table.insert(tags, table.concat({name, filename, tag_cmd:sub(2)}, "\t"))
                end
            end
        end
    end

    FZF {
        prompt = "Help> ",
        source = tags,

        preview = table.concat({
            "rg",
            "--before-context", "1",
            "--after-context", "22",
            "--fixed-strings",
            "{3} {2}", -- argument
        }, " "),

        options = {
            "--with-nth", "1",
            "--delimiter", "\t",
            "--preview-window", "up,25,border-bottom",
        },

        window = {
            width = 78,
            height = 0.9,
        },

        sinklist = function(list)
            local command, line
            if #list == 1 then
                line = list[1]
            else
                command, line = unpack(list)
            end
            if not line then print("Command: " .. command) end

            local name = vim.split(line, "\t", true)[1]
            vim.cmd("help " .. name)
        end,
    }
end

function FZF.buffers()
    local bufinfos = vim.fn.getbufinfo {buflisted = 1}

    local source = vim.tbl_map(function(bufinfo)
        local current = vim.fn.bufnr() == bufinfo.bufnr
        local alternate = vim.fn.bufnr("#") == bufinfo.bufnr
        local readerrors = false -- @XXX

        return ("%3d %1s%1s %s"):format(
            bufinfo.bufnr,
            (current and "%") or (alternate and "#") or "",
            (bufinfo.changed == 1 and "+") or (readerrors and "x") or "",
            bufinfo.name)
    end, bufinfos)

    FZF {
        prompt = "Buffers> ",
        source = source,
        sinklist = function(list)
            local command, line
            if #list == 1 then
                line = list[1]
            else
                command, line = unpack(list)
            end
            if not line then print("Command: " .. command) end

            local bufnr = line:match("^%s*(%d+) ")
            vim.cmd(bufnr .. "buffer")
        end,

        window = {
            width = 0.4,
            height = 0.6,
        },
    }
end
