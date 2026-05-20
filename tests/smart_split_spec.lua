local smart_split = require "smart_split"

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)), 2)
    end
end

local function assert_same(actual, expected, message)
    if not vim.deep_equal(actual, expected) then
        error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)), 2)
    end
end

local function test(name, fn)
    fn()
    print("ok - " .. name)
end

smart_split.setup {}

test("merges nested user options with defaults", function()
    smart_split.setup {
        blocklist = {
            filetype = { "Trouble" },
        },
        heuristics = {
            min_vertical_width = 120,
        },
    }

    local config = smart_split.config()

    assert_same(config.blocklist.filetype, { "Trouble" }, "filetype blocklist")
    assert_equal(config.heuristics.min_vertical_width, 120, "user heuristic")
    assert_equal(config.heuristics.min_horizontal_height, 30, "default heuristic")
    assert_equal(config.move, "respect_options", "default movement strategy")
end)

test("ignores blocked filetypes buftypes and buffer names", function()
    smart_split.setup {
        blocklist = {
            filetype = { "Trouble", "qf" },
            buftype = { "terminal" },
            bufname = { "^diffview://" },
        },
    }

    assert_equal(smart_split.should_ignore { filetype = "help", buftype = "help", bufname = "" }, false, "help is included")
    assert_equal(smart_split.should_ignore { filetype = "Trouble", buftype = "", bufname = "" }, true, "filetype")
    assert_equal(smart_split.should_ignore { filetype = "", buftype = "terminal", bufname = "" }, true, "buftype")
    assert_equal(smart_split.should_ignore { filetype = "", buftype = "", bufname = "diffview://foo" }, true, "bufname")
end)

test("uses custom blocklist predicate", function()
    smart_split.setup {
        blocklist = {
            predicate = function(ctx)
                return ctx.winid == 42
            end,
        },
    }

    assert_equal(smart_split.should_ignore { winid = 42 }, true, "predicate match")
    assert_equal(smart_split.should_ignore { winid = 43 }, false, "predicate miss")
end)

test("detects configurable explicit split commands to ignore", function()
    smart_split.setup {}

    assert_equal(smart_split.is_ignored_command("split"), true, "split")
    assert_equal(smart_split.is_ignored_command("sp foo.txt"), true, "sp")
    assert_equal(smart_split.is_ignored_command("vsplit"), true, "vsplit")
    assert_equal(smart_split.is_ignored_command("vs foo.txt"), true, "vs")
    assert_equal(smart_split.is_ignored_command("vert h lua"), true, "vertical help")
    assert_equal(smart_split.is_ignored_command("hor h windows"), true, "horizontal help")
    assert_equal(smart_split.is_ignored_command("h windows"), false, "plain help")
end)

test("allows explicit command ignore list to be cleared for tests or users", function()
    smart_split.setup {
        ignore = {
            commands = {},
        },
    }

    assert_equal(smart_split.is_ignored_command("vsplit"), false, "cleared ignore command list")
end)

test("consumes pending explicit command override once", function()
    smart_split.setup {}

    smart_split.mark_ignored_command("vsplit")

    assert_equal(smart_split.consume_ignored_command(), "vsplit", "first consume")
    assert_equal(smart_split.consume_ignored_command(), nil, "second consume")
end)

test("chooses vertical for wide short windows with enough editor width", function()
    smart_split.setup {}

    local orientation = smart_split.decide_orientation {
        width = 118,
        height = 14,
        editor_width = 180,
        editor_height = 50,
        visible_textwidths = { 60 },
    }

    assert_equal(orientation, "vertical", "wide short window")
end)

test("chooses vertical for a typical wide horizontal split", function()
    smart_split.setup {}

    local orientation = smart_split.decide_orientation {
        width = 180,
        height = 24,
        editor_width = 180,
        editor_height = 50,
        visible_textwidths = { 60 },
    }

    assert_equal(orientation, "vertical", "typical horizontal split")
end)

test("prefers horizontal first split when the editor is only minimum-column width", function()
    smart_split.setup {
        heuristics = {
            min_columns = 2,
            default_textwidth = 80,
        },
    }

    local orientation = smart_split.decide_orientation {
        width = 100,
        height = 24,
        editor_width = 100,
        editor_height = 50,
        column_count = 1,
        current_orientation = "horizontal",
        visible_textwidths = { 0, 0 },
    }

    assert_equal(orientation, nil, "narrow editor first split")
end)

test("keeps splits horizontal once the maximum column count is reached", function()
    smart_split.setup {
        heuristics = {
            max_columns = 2,
        },
    }

    assert_equal(smart_split.decide_orientation {
        width = 100,
        height = 24,
        editor_width = 200,
        editor_height = 50,
        column_count = 2,
    }, "horizontal", "left column split")

    assert_equal(smart_split.decide_orientation {
        width = 100,
        height = 24,
        editor_width = 200,
        editor_height = 50,
        column_count = 2,
    }, "horizontal", "right column split")
end)

test("leaves already vertical splits alone even when the column limit is reached", function()
    smart_split.setup {
        ignore = {
            commands = {},
        },
        heuristics = {
            max_columns = 2,
        },
    }

    assert_equal(smart_split.decide_orientation {
        width = 100,
        height = 48,
        editor_width = 200,
        editor_height = 50,
        column_count = 2,
        current_orientation = "vertical",
    }, nil, "already vertical")
end)

test("converts already vertical splits when they exceed the column limit", function()
    smart_split.setup {
        ignore = {
            commands = {},
        },
        heuristics = {
            max_columns = 2,
        },
    }

    assert_equal(smart_split.decide_orientation {
        width = 66,
        height = 48,
        editor_width = 200,
        editor_height = 50,
        column_count = 3,
        current_orientation = "vertical",
    }, "horizontal", "over-limit vertical")
end)

test("derives allowed columns from textwidth and clamps to minimum and maximum", function()
    smart_split.setup {
        heuristics = {
            min_columns = 2,
            max_columns = nil,
            default_textwidth = 80,
            textwidth_mode = "visible_max",
        },
    }

    assert_equal(smart_split.allowed_columns {
        editor_width = 210,
        visible_textwidths = { 80, 80 },
    }, 2, "two 80-column buffers")

    assert_equal(smart_split.allowed_columns {
        editor_width = 210,
        visible_textwidths = { 60, 60 },
    }, 3, "three 60-column buffers fit")

    assert_equal(smart_split.allowed_columns {
        editor_width = 150,
        visible_textwidths = { 100, 100 },
    }, 2, "minimum column clamp")
end)

test("allows fixed maximum column override", function()
    smart_split.setup {
        heuristics = {
            min_columns = 1,
            max_columns = 2,
            default_textwidth = 60,
        },
    }

    assert_equal(smart_split.allowed_columns {
        editor_width = 240,
        visible_textwidths = { 60, 60, 60 },
    }, 2, "fixed maximum")
end)

test("can derive allowed columns from the source buffer textwidth", function()
    smart_split.setup {
        heuristics = {
            min_columns = 1,
            max_columns = nil,
            default_textwidth = 80,
            textwidth_mode = "source",
        },
    }

    assert_equal(smart_split.allowed_columns {
        editor_width = 210,
        source_textwidth = 60,
        visible_textwidths = { 80, 80 },
    }, 3, "source textwidth")

    assert_equal(smart_split.allowed_columns {
        editor_width = 210,
        source_textwidth = 0,
        visible_textwidths = { 60, 60 },
    }, 2, "source fallback")
end)

test("collects source textwidth from the window active before WinNew", function()
    local source = vim.api.nvim_get_current_win()
    vim.bo.textwidth = 60
    vim.cmd "split"
    local created = vim.api.nvim_get_current_win()

    local ctx = smart_split.window_context(created, source)

    assert_equal(ctx.source_textwidth, 60, "source textwidth")
    vim.cmd "only"
end)

test("chooses horizontal for narrow windows or constrained editor width", function()
    smart_split.setup {}

    assert_equal(smart_split.decide_orientation {
        width = 72,
        height = 38,
        editor_width = 180,
        editor_height = 50,
    }, "horizontal", "narrow window")

    assert_equal(smart_split.decide_orientation {
        width = 118,
        height = 14,
        editor_width = 90,
        editor_height = 50,
    }, "horizontal", "constrained editor")
end)

test("leaves balanced windows unchanged", function()
    smart_split.setup {}

    local orientation = smart_split.decide_orientation {
        width = 92,
        height = 32,
        editor_width = 160,
        editor_height = 50,
    }

    assert_equal(orientation, nil, "balanced window")
end)

test("maps movement strategies to commands", function()
    assert_same(smart_split.movement_commands("right", "vertical"), { "wincmd L" }, "right vertical")
    assert_same(smart_split.movement_commands("bottom", "horizontal"), { "wincmd J" }, "bottom horizontal")
    assert_same(smart_split.movement_commands("rotate_or_exchange", "vertical"), { "wincmd x", "wincmd R", "wincmd L" }, "vertical preserving")
    assert_same(smart_split.movement_commands("rotate_or_exchange", "horizontal"), { "wincmd x", "wincmd r", "wincmd J" }, "horizontal preserving")
    assert_same(smart_split.movement_commands("respect_options", "vertical", { splitright = true }), { "wincmd L" }, "splitright vertical")
    assert_same(smart_split.movement_commands("respect_options", "vertical", { splitright = false }), { "wincmd H" }, "nosplitright vertical")
    assert_same(smart_split.movement_commands("respect_options", "horizontal", { splitbelow = true }), { "wincmd J" }, "splitbelow horizontal")
    assert_same(smart_split.movement_commands("respect_options", "horizontal", { splitbelow = false }), { "wincmd K" }, "nosplitbelow horizontal")
end)

test("does not move a window that already has the desired orientation", function()
    smart_split.setup {
        move = "respect_options",
    }

    assert_same(smart_split.commands_for_context({
        current_orientation = "horizontal",
        splitbelow = true,
        splitright = true,
    }, "horizontal"), {}, "already horizontal")

    assert_same(smart_split.commands_for_context({
        current_orientation = "vertical",
        splitbelow = true,
        splitright = true,
    }, "vertical"), {}, "already vertical")

    assert_same(smart_split.commands_for_context({
        current_orientation = "horizontal",
        splitbelow = true,
        splitright = true,
    }, "vertical"), { "wincmd L" }, "horizontal to vertical")
end)

test("calculates restored split height from the source window height", function()
    assert_equal(smart_split.target_split_height { source_height = 48 }, 24, "even source height")
    assert_equal(smart_split.target_split_height { source_height = 23 }, 11, "odd source height")
    assert_equal(smart_split.target_split_height { source_height = 1 }, nil, "too small")
end)

test("writes trace logs when configured", function()
    local logfile = vim.fn.tempname()

    smart_split.setup {
        log = {
            level = "trace",
            file = logfile,
        },
    }
    vim.fn.writefile({}, logfile)

    smart_split.log("debug", "visible debug")
    smart_split.log("trace", "visible trace")

    local lines = vim.fn.readfile(logfile)
    assert_equal(#lines, 2, "trace log line count")
    assert_equal(lines[1]:match("visible debug") ~= nil, true, "debug log message")
    assert_equal(lines[2]:match("visible trace") ~= nil, true, "trace log message")
end)

test("filters logs below the configured level", function()
    local logfile = vim.fn.tempname()

    smart_split.setup {
        log = {
            level = "warn",
            file = logfile,
        },
    }
    vim.fn.writefile({}, logfile)

    smart_split.log("info", "hidden info")
    smart_split.log("error", "visible error")

    local lines = vim.fn.readfile(logfile)
    assert_equal(#lines, 1, "warn log line count")
    assert_equal(lines[1]:match("%[ERROR%] visible error") ~= nil, true, "error log message")
end)
