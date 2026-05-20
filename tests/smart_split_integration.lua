local smart_split = require "smart_split"

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)), 2)
    end
end

local function assert_true(actual, message)
    if not actual then
        error(message, 2)
    end
end

local function settle()
    vim.cmd "sleep 30m"
end

vim.o.columns = 200
vim.o.lines = 50
vim.o.splitbelow = true
vim.o.splitright = true

smart_split.setup {
    ignore = {
        commands = {},
    },
    heuristics = {
        min_columns = 2,
        max_columns = 2,
        default_textwidth = 80,
        textwidth_mode = "visible_max",
    },
    move = "respect_options",
}

vim.cmd "help help"
settle()

local ctx = smart_split.window_context(vim.api.nvim_get_current_win())
local screenpos = vim.fn.win_screenpos(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 2, "help creates a second column")
assert_true(screenpos[2] > 1, "help opens on the right when splitright is set")

vim.cmd "wincmd h"
vim.cmd "split"
settle()

ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 2, "left split keeps two columns")
assert_equal(ctx.current_orientation, "horizontal", "left split stays horizontal")

vim.cmd "wincmd l"
vim.cmd "split"
settle()

ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 2, "right split keeps two columns")
assert_equal(ctx.current_orientation, "horizontal", "right split stays horizontal")

vim.cmd "split"
settle()

ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 2, "bottom-right split keeps two columns")
assert_equal(ctx.current_orientation, "horizontal", "bottom-right split stays horizontal")

print("ok - smart split integration workflow")
