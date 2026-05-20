local smart_split = require "smart_split"

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)), 2)
    end
end

local function settle()
    vim.cmd "sleep 30m"
end

vim.o.columns = 100
vim.o.lines = 50
vim.o.splitbelow = true
vim.o.splitright = true

smart_split.setup {
    ignore = {
        commands = {},
    },
    heuristics = {
        min_columns = 2,
        default_textwidth = 80,
        textwidth_mode = "visible_max",
    },
    move = "respect_options",
}

vim.cmd "split"
settle()

local ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 1, "narrow split does not create a column")
assert_equal(ctx.current_orientation, "horizontal", "narrow split remains horizontal")

print("ok - narrow editors prefer horizontal splits")
