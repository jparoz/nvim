local M = {}

M.swapBuffers = function(a, b)
    local wins = vim.api.nvim_tabpage_list_wins(0)

    a = a and wins[a] or 0 -- default to current window
    b = b and wins[b] or wins[#wins] -- default to last window

    local a_buf = vim.api.nvim_win_get_buf(a)
    local b_buf = vim.api.nvim_win_get_buf(b)

    vim.api.nvim_win_set_buf(a, b_buf)
    vim.api.nvim_win_set_buf(b, a_buf)

    vim.api.nvim_set_current_win(b)
end

return M
