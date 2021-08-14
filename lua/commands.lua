-- Open a terminal in the current file's directory
vim.cmd [[
command! -nargs=* Terminal lua Terminal("<args>")
command! -nargs=* STerminal split | Terminal <args>
command! -nargs=* VTerminal vsplit | Terminal <args>
]]

-- Open a terminal in the given dir, with escape bound to return to normal mode
function Terminal(dir)
    if dir == "" then
        vim.cmd("terminal")
    else
        local cwd = vim.fn.getcwd()
        vim.cmd("lcd " .. dir .. "\nterminal\nlcd " .. cwd)
    end

    vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", "<C-\\><C-n>", {noremap=true})
end

vim.cmd [[
function! SynStack()
    if !exists("*synstack")
        return
    endif
    return join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ", ")
endfunc
]]

-- @Todo: rewrite if necessary
-- Run the last command in an open terminal window in this tab
vim.cmd [[
function! RedoTerminal()
    let found = 0
    let current_win = win_getid()
    for buf in tabpagebuflist()
        if match(bufname(buf), "^term://") != -1
            let found = 1
            if !(empty(win_findbuf(buf)))
                let job_id = getbufvar(buf, "terminal_job_id")
                call chansend(job_id, "\x1B[A\x0D")

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
]]
