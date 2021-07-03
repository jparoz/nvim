augroup MarkdownPreview
	au BufNew <buffer> VimRShowTools
augroup END

nnoremap <Leader><CR> :VimRToggleTools<CR>

setlocal linebreak
setlocal conceallevel=2
