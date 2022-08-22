vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.wo.linebreak = true
vim.wo.conceallevel = 2

function MarkdownGetIndent()
    local lnum = vim.v.lnum
    local line = vim.api.nvim_buf_get_lines(0, lnum-1, lnum, false)

    -- Try to find an unordered list prefix
    local first_unordered = line:find("^%s*[%*%+%-]%s*()")

    -- Try to find an ordered list prefix
    local first_ordered = line:find("^%s*%d+%.%s*()")

    -- @Todo: show this in statusline for debugging purposes

    -- @Fixme: this doesn't work
    return first_unordered or first_ordered or vim.fn.indent(lnum)
end
-- vim.bo.indentexpr = "v:lua.MarkdownGetIndent()"
