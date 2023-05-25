vim.bo.textwidth = 100
vim.wo.signcolumn = "yes"

vim.bo.makeprg = "cargo"


--[=[
vim.cmd [[
augroup CargoCheckOnSave
  autocmd! BufWritePost <buffer> Make check
augroup END
]]

MakeIgnoreLines = vim.tbl_extend("force", MakeIgnoreLines or {}, {cargo = {
    "generated %d+ warning",
    "Checking [^ ]+ v%d+%.%d+%.%d+",
}})
--]=]
