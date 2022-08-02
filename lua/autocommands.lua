-- Hide line numbers in terminal buffers
vim.cmd [[
au TermOpen * setlocal nonumber
au TermOpen * setlocal signcolumn=no
]]


-- Automatically create necessary directories when editing a new file
-- e.g. creates directories foo and bar if they don't exist when running:
-- :e foo/bar/baz.txt
vim.cmd [[
augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
]]


-- From the vim help files: *last-position-jump*
vim.cmd [[
augroup LastPositionJump
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
augroup END
]]


-- Automatically open quickfix window when a command runs
-- currently commented because we don't want this right now
vim.cmd ""--[[
augroup AutoOpenQuickFix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
augroup END
]]


-- Only show the first line of diagnostics
vim.api.nvim_create_autocmd("DiagnosticChanged", {callback = function()
    for _, diag in ipairs(vim.diagnostic.get()) do
        diag.message = diag.message:match("[^\n]+")
    end
end})
