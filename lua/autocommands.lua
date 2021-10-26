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

-- From the vim help files: *last-position-jump*
vim.cmd [[
augroup LastPositionJump
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
augroup END
]]
