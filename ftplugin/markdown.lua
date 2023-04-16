vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.wo.linebreak = true
vim.wo.conceallevel = 2
vim.wo.concealcursor = "nc"
vim.bo.textwidth = 0
vim.wo.signcolumn = "yes"
-- vim.o.showtabline = 2  -- always

vim.keymap.set("n", "<Leader>]", function()
    vim.cmd "split"
    vim.lsp.buf.definition()
end)
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "gj", "j")
vim.keymap.set("n", "gk", "k")
