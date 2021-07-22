local cmd = vim.cmd
-- @Todo: rewrite
--[[
nnoremap <buffer> <Leader><CR> :w<CR>:call deletebufline(bufadd("LOVE output"), 1, "$")<CR>
            \:silent call
            \ jobstart(["/Applications/love.app/Contents/MacOS/love",
            \ getcwd()], {
            \ "on_stdout":"LOVEQuickFix",
            \ "stdout_buffered":1})<CR>
            \ | redraw!

function! LOVEQuickFix(j, d, e)
    cgetexpr a:d
endfunction
]]

-- @Note: for some reason vim.bo.errorformat gives an error.
cmd [[setlocal errorformat=]]
cmd [[setlocal errorformat+=lua:\ %f:%l:%m]]
cmd [[setlocal errorformat+=%-G\	[string%.%#]]
cmd [[setlocal errorformat+=%-G\	[C]%.%#]]
cmd [[setlocal errorformat+=%-Gstack\ traceback:%.%#]]
cmd [[setlocal errorformat+=Error:%*[^:]:\ %f:%l:%m]]
cmd [[setlocal errorformat+=Error:\ %f:%l:%m]]
cmd [[setlocal errorformat+=\	%f:%l:%m]]
cmd [[setlocal errorformat+=%f:%l:%m]]

vim.wo.signcolumn = "yes"
