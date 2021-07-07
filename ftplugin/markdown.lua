--[[
augroup MarkdownPreview
	au BufNew <buffer> VimRShowTools
augroup END

nnoremap <Leader><CR> :VimRToggleTools<CR>
]]

vim.wo.linebreak = true
vim.wo.conceallevel = 2
