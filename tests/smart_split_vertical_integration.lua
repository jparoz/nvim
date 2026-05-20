local smart_split = require "smart_split"

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)), 2)
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

vim.cmd "vsplit"
settle()

local ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 2, "vsplit keeps two columns")
assert_equal(ctx.current_orientation, "vertical", "vsplit stays vertical without command ignore")

vim.cmd "vsplit"
settle()

ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 2, "second non-ignored vsplit respects column cap")
assert_equal(ctx.current_orientation, "horizontal", "second non-ignored vsplit is converted to horizontal")
assert_equal(ctx.height >= 20 and ctx.height <= 26, true, "converted vsplit gets split-like height")

for _ = 1, 4 do
    vim.cmd "vsplit"
    settle()
end

ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 2, "repeated non-ignored vsplit respects column cap")

print("ok - vertical splits stay vertical without explicit command ignore")
