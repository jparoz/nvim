--[[
augroup MarkdownPreview
	au BufNew <buffer> VimRShowTools
augroup END

nnoremap <Leader><CR> :VimRToggleTools<CR>
]]

vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.wo.linebreak = true
vim.wo.conceallevel = 2
