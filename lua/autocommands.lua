-- Hide line numbers in terminal buffers
vim.cmd [[
au TermOpen * setlocal nonumber
au TermOpen * setlocal signcolumn=no
]]

vim.cmd [[
augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
]]
