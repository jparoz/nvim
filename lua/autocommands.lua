-- Hide line numbers in terminal buffers
vim.cmd [[
au TermOpen * setlocal nonumber
au TermOpen * setlocal signcolumn=no
]]
