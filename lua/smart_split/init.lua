local M = {}

local defaults = {
    blocklist = {
        filetype = {},
        buftype = {},
        bufname = {},
        predicate = nil,
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
        command_predicate = nil,
    },
    heuristics = {
        min_vertical_width = 100,
        min_horizontal_height = 30,
        min_horizontal_width = 80,
        min_columns = 2,
        max_columns = nil,
        default_textwidth = 80,
        textwidth_mode = "visible_max",
        prefer_vertical_after_columns = 2,
        wide_ratio = 1.8,
    },
    move = "respect_options",
    delay = 10,
    log = {
        level = "off",
        file = vim.fn.stdpath("state") .. "/smart_split.log",
        notify = false,
    },
}

local config = vim.deepcopy(defaults)
local augroup = vim.api.nvim_create_augroup("SmartSplit", {})
local pending_ignored_command = nil
local levels = {
    off = 0,
    error = 1,
    warn = 2,
    info = 3,
    debug = 4,
    trace = 5,
}

local function list_contains(list, value)
    for _, item in ipairs(list or {}) do
        if item == value then
            return true
        end
    end

    return false
end

local function current_config()
    return config
end

local function merge_config(opts)
    config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

function M.config()
    return current_config()
end

function M.log(level, message)
    local configured_level = levels[config.log.level] or levels.off
    local message_level = levels[level] or levels.info

    if configured_level == levels.off or message_level > configured_level then
        return
    end

    local line = ("%s [%s] %s"):format(os.date("%Y-%m-%d %H:%M:%S"), level:upper(), message)

    if config.log.file and config.log.file ~= "" then
        vim.fn.mkdir(vim.fn.fnamemodify(config.log.file, ":h"), "p")
        vim.fn.writefile({ line }, config.log.file, "a")
    end

    if config.log.notify then
        vim.notify("smart_split: " .. message, vim.log.levels[level:upper()] or vim.log.levels.INFO)
    end
end

function M.should_ignore(ctx)
    local blocklist = config.blocklist

    if list_contains(blocklist.filetype, ctx.filetype) then
        M.log("debug", ("ignoring win=%s because filetype=%s is blocklisted"):format(ctx.winid or "?", ctx.filetype))
        return true
    end

    if list_contains(blocklist.buftype, ctx.buftype) then
        M.log("debug", ("ignoring win=%s because buftype=%s is blocklisted"):format(ctx.winid or "?", ctx.buftype))
        return true
    end

    for _, pattern in ipairs(blocklist.bufname or {}) do
        if (ctx.bufname or ""):match(pattern) then
            M.log("debug", ("ignoring win=%s because bufname=%s matched %s"):format(ctx.winid or "?", ctx.bufname or "", pattern))
            return true
        end
    end

    if blocklist.predicate and blocklist.predicate(ctx) then
        M.log("debug", ("ignoring win=%s because blocklist predicate matched"):format(ctx.winid or "?"))
        return true
    end

    return false
end

local function normalize_command(command)
    return (command or ""):gsub("^%s*:", ""):lower()
end

function M.is_ignored_command(command)
    local normalized = normalize_command(command)

    for _, pattern in ipairs(config.ignore.commands or {}) do
        if normalized:match(pattern) then
            return true
        end
    end

    if config.ignore.command_predicate and config.ignore.command_predicate(normalized) then
        return true
    end

    return false
end

function M.mark_ignored_command(command)
    local normalized = normalize_command(command)

    if M.is_ignored_command(normalized) then
        pending_ignored_command = normalized
        M.log("trace", ("marked explicit command override command=%s"):format(normalized))
    else
        pending_ignored_command = nil
    end
end

function M.consume_ignored_command()
    local command = pending_ignored_command
    pending_ignored_command = nil
    return command
end

local function effective_textwidth(ctx)
    local heuristics = config.heuristics

    if heuristics.textwidth_mode == "source" then
        local source_textwidth = ctx.source_textwidth or 0
        if source_textwidth > 0 then
            return source_textwidth
        end

        return heuristics.default_textwidth
    end

    local max_textwidth = 0
    for _, textwidth in ipairs(ctx.visible_textwidths or {}) do
        if textwidth > max_textwidth then
            max_textwidth = textwidth
        end
    end

    if max_textwidth > 0 then
        return max_textwidth
    end

    return heuristics.default_textwidth
end

function M.allowed_columns(ctx)
    local heuristics = config.heuristics
    local min_columns = heuristics.min_columns or 1
    local max_columns = heuristics.max_columns

    local textwidth = math.max(effective_textwidth(ctx), 1)
    local allowed = math.max(min_columns, math.floor(ctx.editor_width / textwidth))

    if max_columns then
        allowed = math.min(allowed, max_columns)
    end

    return allowed
end

function M.decide_orientation(ctx)
    local heuristics = config.heuristics
    local column_count = ctx.column_count or 1
    local allowed_columns = M.allowed_columns(ctx)
    local target_column_width = math.floor(ctx.editor_width / math.max(column_count + 1, 1))

    if ctx.current_orientation == "vertical" and column_count <= allowed_columns then
        M.log("trace", ("decision=unchanged reason=already-vertical win=%s columns=%s allowed=%s"):format(ctx.winid or "?", column_count, allowed_columns))
        return nil
    end

    if column_count >= allowed_columns then
        M.log("trace", ("decision=horizontal reason=max-columns win=%s columns=%s allowed=%s"):format(ctx.winid or "?", column_count, allowed_columns))
        return "horizontal"
    end

    if ctx.editor_width < heuristics.min_vertical_width then
        M.log("trace", ("decision=horizontal reason=editor-width win=%s width=%s height=%s editor_width=%s"):format(ctx.winid or "?", ctx.width, ctx.height, ctx.editor_width))
        return "horizontal"
    end

    if ctx.width <= heuristics.min_horizontal_width then
        M.log("trace", ("decision=horizontal reason=window-width win=%s width=%s height=%s"):format(ctx.winid or "?", ctx.width, ctx.height))
        return "horizontal"
    end

    local ratio = ctx.width / math.max(ctx.height, 1)
    if ctx.width >= heuristics.min_vertical_width
        and ctx.height < heuristics.min_horizontal_height
        and allowed_columns >= column_count + 1
        and target_column_width >= heuristics.min_horizontal_width
        and ratio >= heuristics.wide_ratio then
        M.log("trace", ("decision=vertical reason=wide-short win=%s width=%s height=%s ratio=%.2f target_column_width=%s"):format(ctx.winid or "?", ctx.width, ctx.height, ratio, target_column_width))
        return "vertical"
    end

    M.log("trace", ("decision=unchanged win=%s width=%s height=%s ratio=%.2f"):format(ctx.winid or "?", ctx.width, ctx.height, ratio))
    return nil
end

function M.movement_commands(strategy, orientation, opts)
    opts = opts or {}

    if orientation == "vertical" then
        if strategy == "respect_options" then
            return { opts.splitright == false and "wincmd H" or "wincmd L" }
        end

        if strategy == "right" then
            return { "wincmd L" }
        end

        if strategy == "rotate_or_exchange" then
            return { "wincmd x", "wincmd R", "wincmd L" }
        end
    end

    if orientation == "horizontal" then
        if strategy == "respect_options" then
            return { opts.splitbelow == false and "wincmd K" or "wincmd J" }
        end

        if strategy == "bottom" then
            return { "wincmd J" }
        end

        if strategy == "rotate_or_exchange" then
            return { "wincmd x", "wincmd r", "wincmd J" }
        end
    end

    return {}
end

local function count_columns(layout)
    local kind = layout[1]
    local children = layout[2]

    if kind == "leaf" then
        return 1
    end

    if kind == "row" then
        local columns = 0
        for _, child in ipairs(children) do
            columns = columns + count_columns(child)
        end

        return columns
    end

    local columns = 1
    for _, child in ipairs(children) do
        columns = math.max(columns, count_columns(child))
    end

    return columns
end

local function parent_kind_for_window(layout, winid, parent_kind)
    local kind = layout[1]

    if kind == "leaf" then
        return layout[2] == winid and parent_kind or nil
    end

    for _, child in ipairs(layout[2]) do
        local found = parent_kind_for_window(child, winid, kind)
        if found then
            return found
        end
    end

    return nil
end

local function current_orientation(layout, winid)
    local parent_kind = parent_kind_for_window(layout, winid, nil)

    if parent_kind == "row" then
        return "vertical"
    end

    if parent_kind == "col" then
        return "horizontal"
    end

    return nil
end

local function is_floating(winid)
    return vim.api.nvim_win_get_config(winid).relative ~= ""
end

local function visible_textwidths()
    local textwidths = {}

    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if not is_floating(winid) then
            local bufnr = vim.api.nvim_win_get_buf(winid)
            table.insert(textwidths, vim.bo[bufnr].textwidth)
        end
    end

    return textwidths
end

local function source_textwidth(source_winid)
    if source_winid and vim.api.nvim_win_is_valid(source_winid) then
        local source_bufnr = vim.api.nvim_win_get_buf(source_winid)
        return vim.bo[source_bufnr].textwidth
    end

    return nil
end

function M.window_context(winid, source_winid)
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local layout = vim.fn.winlayout()

    return {
        winid = winid,
        bufnr = bufnr,
        width = vim.api.nvim_win_get_width(winid),
        height = vim.api.nvim_win_get_height(winid),
        editor_width = vim.o.columns,
        editor_height = vim.o.lines,
        column_count = count_columns(layout),
        current_orientation = current_orientation(layout, winid),
        visible_textwidths = visible_textwidths(),
        source_textwidth = source_textwidth(source_winid),
        filetype = vim.bo[bufnr].filetype,
        buftype = vim.bo[bufnr].buftype,
        bufname = vim.api.nvim_buf_get_name(bufnr),
    }
end

function M.commands_for_context(ctx, orientation)
    if ctx.current_orientation == orientation then
        M.log("debug", ("movement skipped win=%s orientation=%s already satisfied"):format(ctx.winid or "?", orientation))
        return {}
    end

    return M.movement_commands(config.move, orientation, {
        splitbelow = ctx.splitbelow,
        splitright = ctx.splitright,
    })
end

function M.target_split_height(ctx)
    if not ctx.source_height or ctx.source_height < 2 then
        return nil
    end

    return math.max(1, math.floor(ctx.source_height / 2))
end

local function apply_strategy(ctx, orientation)
    if type(config.move) == "function" then
        M.log("debug", ("applying custom movement win=%s orientation=%s"):format(ctx.winid, orientation))
        config.move(ctx, orientation)
        return
    end

    ctx.splitbelow = vim.o.splitbelow
    ctx.splitright = vim.o.splitright

    for _, command in ipairs(M.commands_for_context(ctx, orientation)) do
        M.log("debug", ("applying command=%s win=%s orientation=%s strategy=%s"):format(command, ctx.winid, orientation, config.move))
        vim.cmd(command)

        if orientation == "horizontal" then
            local target_height = M.target_split_height(ctx)
            if target_height then
                vim.cmd(("resize %d"):format(target_height))
            end
        end

        local updated_win = vim.api.nvim_get_current_win()
        local updated_ctx = M.window_context(updated_win)
        if M.decide_orientation(updated_ctx) ~= orientation then
            M.log("debug", ("movement accepted command=%s win=%s"):format(command, updated_win))
            return
        end
    end
end

function M.adjust(winid, source_winid)
    if not vim.api.nvim_win_is_valid(winid) or is_floating(winid) then
        M.log("debug", ("skipping invalid or floating win=%s"):format(winid))
        return
    end

    local previous_win = vim.api.nvim_get_current_win()
    local ok, err = pcall(function()
        vim.api.nvim_set_current_win(winid)
        local ctx = M.window_context(winid, source_winid)
        if source_winid and vim.api.nvim_win_is_valid(source_winid) then
            ctx.source_height = vim.api.nvim_win_get_height(source_winid)
        end
        M.log("trace", ("adjusting win=%s buf=%s ft=%s bt=%s width=%s height=%s editor_width=%s editor_height=%s columns=%s current_orientation=%s source_tw=%s"):format(
            ctx.winid,
            ctx.bufnr,
            ctx.filetype,
            ctx.buftype,
            ctx.width,
            ctx.height,
            ctx.editor_width,
            ctx.editor_height,
            ctx.column_count,
            ctx.current_orientation,
            ctx.source_textwidth
        ))

        if M.should_ignore(ctx) then
            return
        end

        local orientation = M.decide_orientation(ctx)
        if orientation then
            apply_strategy(ctx, orientation)
        end
    end)

    if vim.api.nvim_win_is_valid(previous_win) then
        vim.api.nvim_set_current_win(previous_win)
    end

    if not ok then
        M.log("error", tostring(err))
        vim.notify(("smart_split: %s"):format(err), vim.log.levels.WARN)
    end
end

function M.setup(opts)
    merge_config(opts)
    M.log("debug", ("setup move=%s delay=%s log_level=%s"):format(tostring(config.move), config.delay, config.log.level))
    vim.api.nvim_clear_autocmds { group = augroup }

    vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = augroup,
        desc = "Track explicit split commands smart_split should not reshape",
        pattern = ":",
        callback = function()
            M.mark_ignored_command(vim.fn.getcmdline())
        end,
    })

    vim.api.nvim_create_autocmd("WinNew", {
        group = augroup,
        desc = "Adjust new split orientation using smart_split heuristics",
        callback = function()
            local winid = vim.api.nvim_get_current_win()
            local source_winid = vim.fn.win_getid(vim.fn.winnr("#"))
            local ignored_command = M.consume_ignored_command()
            M.log("trace", ("WinNew captured win=%s source_win=%s ignored_command=%s"):format(winid, source_winid, ignored_command))

            if ignored_command then
                M.log("debug", ("ignoring win=%s because explicit command=%s requested split orientation"):format(winid, ignored_command))
                return
            end

            vim.defer_fn(function()
                M.adjust(winid, source_winid)
            end, config.delay)
        end,
    })
end

return M
