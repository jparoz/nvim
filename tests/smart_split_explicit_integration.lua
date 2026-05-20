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
    heuristics = {
        min_columns = 2,
        max_columns = 2,
        default_textwidth = 80,
        textwidth_mode = "visible_max",
    },
    move = "respect_options",
}

vim.fn.feedkeys(":vsplit\r", "xt")
settle()

local ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 2, "explicit vsplit keeps two columns")
assert_equal(ctx.current_orientation, "vertical", "explicit vsplit stays vertical")

vim.cmd "only"

vim.fn.feedkeys(":split\r", "xt")
settle()

ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 1, "explicit split does not create a column")
assert_equal(ctx.current_orientation, "horizontal", "explicit split stays horizontal")

print("ok - explicit split commands bypass smart split")
