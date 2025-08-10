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

-- TODO: convert this to a separate filetype,
--       and use ftdetect to check the filepath.
local notes_path = vim.fn.resolve(vim.fn.expand("~/notes"))
local cwd = vim.fn.expand("%:p")

-- If cwd starts with notes_path,
-- then use obsidian-like configuration.
if cwd:find(notes_path) == 1 then
    vim.bo.textwidth = 66

    -- Start marksman LSP (configured to have autostart = false)
    vim.cmd [[ LspStart ]]

    -- Configure conceal
    vim.wo.conceallevel = 2
    vim.wo.concealcursor = "nc"

    -- Underline links
    vim.api.nvim_set_hl(0, "@markup.link.label", { underline = true })

    -- TODO: set highlight to highlight nonexistent linked files
    -- See :h api-highlights

end
