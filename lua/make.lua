local Make = {}

Make.config = {
    window = {
        style = "float", -- "float" | "split"

        border = "rounded",

        width = 0.8,
        height = 0.8,

        split_cmd = "botright 12split",
    },

    close_on_success = true,
    focus = false,
}

local state = {
    bufnr = nil,
    winnr = nil,
    job_id = nil,
}

local function create_terminal_window()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.bo[buf].bufhidden = "wipe"

    local win

    if Make.config.window.style == "float" then
        local width = math.floor(vim.o.columns * Make.config.window.width)
        local height = math.floor(vim.o.lines * Make.config.window.height)

        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        win = vim.api.nvim_open_win(buf, Make.config.focus, {
            relative = "editor",
            style = "minimal",
            border = Make.config.window.border,

            width = width,
            height = height,

            row = row,
            col = col,
        })
    else
        vim.cmd(Make.config.window.split_cmd)

        win = vim.api.nvim_get_current_win()

        vim.api.nvim_win_set_buf(win, buf)

        if not Make.config.focus then
            vim.cmd("wincmd p")
        end
    end

    state.bufnr = buf
    state.winnr = win

    return buf, win
end

local function close_window()
    vim.schedule(function()
        if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
            vim.api.nvim_win_close(state.winnr, true)
        end

        state.winnr = nil
        state.bufnr = nil
    end)
end

function Make.run(args)
    if state.job_id then
        vim.notify("Make already running", vim.log.levels.WARN)
        return
    end

    local curbuf = vim.api.nvim_get_current_buf()

    local makeprg = vim.bo[curbuf].makeprg
    if makeprg == "" then
        makeprg = "make"
    end

    if args and args ~= "" then
        local replaced

        makeprg, replaced = makeprg:gsub("%$%*", args)

        if replaced == 0 then
            makeprg = makeprg .. " " .. args
        end
    end

    local cmd = vim.fn.expandcmd(makeprg)

    local _buf, win = create_terminal_window()

    vim.notify("Starting make: " .. cmd)

    local current_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(win)

    state.job_id = vim.fn.jobstart(cmd, {
        term = true,
        on_exit = function(_, code)
            vim.schedule(function()
                state.job_id = nil

                vim.notify(
                    ("Make finished (exit code %d)"):format(code),
                    code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
                )

                -- Populate quickfix from terminal contents
                local efm = vim.bo[curbuf].errorformat

                if efm ~= "" and state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
                    local lines = vim.api.nvim_buf_get_lines(
                        state.bufnr,
                        0,
                        -1,
                        false
                    )

                    vim.fn.setqflist({}, " ", {
                        title = cmd,
                        lines = lines,
                        efm = efm,
                    })

                    vim.cmd("doautocmd QuickFixCmdPost")
                end

                if code == 0 and Make.config.close_on_success then
                    close_window()
                end
            end)
        end,
    })

    if Make.config.focus then
        -- Enter insert mode in terminal if focused
        vim.cmd("startinsert")
    else
        -- Else set current win back to previous
        vim.api.nvim_set_current_win(current_win)
    end

    if state.job_id <= 0 then
        vim.notify("Failed to start make", vim.log.levels.ERROR)
        close_window()
        state.job_id = nil
        return
    end
end

function Make.stop()
    if state.job_id then
        vim.fn.jobstop(state.job_id)
        state.job_id = nil
    end
end

_G.Make = Make

vim.api.nvim_create_user_command("Make", function(opts)
    Make.run(opts.args)
end, {
    nargs = "*",
})

vim.api.nvim_create_user_command("MakeStop", function()
    Make.stop()
end, {})

vim.cmd([[
cnoreabbrev <expr> make
    \ getcmdtype() ==# ':' && getcmdline() ==# 'make'
    \ ? 'Make'
    \ : 'make'
]])
