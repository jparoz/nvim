local cmd = vim.cmd
local fn = vim.fn

-- Open a terminal in the current file's directory
cmd [[
command! -nargs=* Terminal lua current_dir_terminal("<args>")
command! -nargs=* STerminal split | Terminal <args>
command! -nargs=* VTerminal vsplit | Terminal <args>
]]

-- Open a terminal in the current file's directory
function current_dir_terminal(arg)
    vim.env.VIM_CURRENT_DIR = fn.expand("%:p:h")
    cmd(":terminal " .. arg)
    vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", "<C-\\><C-n>", {noremap=true})
    fn.chansend(vim.b.terminal_job_id, " cd $VIM_CURRENT_DIR\n clear\n")
end

-- @Todo: rewrite if necessary
-- Run the last command in an open terminal window in this tab
--[[
function! RedoTerminal()
    let found = 0
    let current_win = win_getid()
    for buf in tabpagebuflist()
        if match(bufname(buf), "^term://") != -1
            let found = 1
            if !(empty(win_findbuf(buf)))
                let job_id = getbufvar(buf, "terminal_job_id")
                -- <Up><Enter>
                call chansend(job_id, "[A")

                let wins = win_findbuf(buf)
                if !empty(wins)
                    call win_gotoid(wins[0])
                    normal! G
                    call win_gotoid(current_win)
                endif
            endif
        endif
    endfor

    if !found
        echo "No terminal window open"
    else
        echo ""
    endif
endfunction

-- @Todo: move to mappings.lua
-- nnoremap <Enter> :call RedoTerminal()<CR>
]]
