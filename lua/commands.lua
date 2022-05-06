-- Open a terminal in the current file's directory
vim.cmd [[
command! -nargs=* Terminal lua Terminal("<args>")
command! -nargs=* STerminal split | Terminal <args>
command! -nargs=* VTerminal aboveleft vsplit | Terminal <args>
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

-- Convert the current buffer containing an SBV file into SRT format.
vim.cmd [[command! -nargs=* SBV2SRT lua SBV2SRT("<args>")]]
function SBV2SRT()
    local caption_count = 1
    local line_nr = 1

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    for i, line in ipairs(lines) do
        local pat = "(%d%d?):(%d%d:%d%d%.%d%d%d),(%d%d?):(%d%d:%d%d%.%d%d%d)"
        if line:find(pat) then
            vim.api.nvim_buf_set_lines(0, line_nr-1, line_nr, true, {
                tostring(caption_count),
                ("%02d:%s --> %02d:%s"):format(line:match(pat)),
            })
            caption_count = caption_count + 1
            line_nr = line_nr + 1
        elseif i < #lines and line ~= "" and lines[i+1] ~= "" then
            vim.api.nvim_buf_set_lines(0, line_nr-1, line_nr, true, {
                line .. "\r"
            })
        elseif i == #lines then
            vim.api.nvim_buf_set_lines(0, line_nr, line_nr, true, {""})
        end
        line_nr = line_nr + 1
    end

    local filename = vim.api.nvim_buf_get_name(0)
    local newname = filename:gsub("%.sbv$", ".srt")
    print(newname)
    vim.api.nvim_buf_set_name(0, newname)
    -- vim.cmd [[write]]
end

-- Convert the current buffer containing markers exported from Premiere Pro as a
-- .txt file into YouTube Chapters format.
vim.cmd [[command! -nargs=* YTChapters lua YTChapters("<args>")]]
function YTChapters()
    -- delete the first line
    vim.cmd [[normal! ggdd]]

    -- substitute to achieve the correct format
    vim.cmd [[silent %sub/^[^\t]\+\t\t\t\d\d[;:]\(\d\d\)[;:]\(\d\d\)[;:]\d\d\t\t\t\([^\t]\+\).*$/\1:\2 \3]]

    -- delete leading zeroes
    vim.cmd [[silent %sub/^0\(\d\)/\1]]
end

-- Better :grep
-- From: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
vim.cmd [[
function! Grep(...)
	return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup BetterGrep
	autocmd!
	autocmd QuickFixCmdPost cgetexpr cwindow
	autocmd QuickFixCmdPost lgetexpr lwindow
augroup END
]]

-- Better :make
vim.cmd [[
cnoreabbrev <expr> make (getcmdtype() ==# ':' && getcmdline() ==# 'make') ? 'silent make!' : 'make'
]]
