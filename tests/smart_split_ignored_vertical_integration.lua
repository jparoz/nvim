local smart_split = require "smart_split"

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)), 2)
    end
end

local function settle()
    vim.cmd "sleep 30m"
end

vim.o.columns = 240
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

for _ = 1, 4 do
    vim.fn.feedkeys(":vsplit\r", "xt")
    settle()
end

local ctx = smart_split.window_context(vim.api.nvim_get_current_win())
assert_equal(ctx.column_count, 5, "ignored vsplit is not capped")

print("ok - ignored vertical splits bypass column cap")
