vim.g.rustfmt_autosave = 1
vim.bo.textwidth = 100
vim.wo.signcolumn = "yes"


function RustQuickfix()
    local qf = vim.fn.getqflist()

    local new_qf = vim.fn.filter(qf, function(_, entry)
        if entry.text:find("generated %d+ warning") then
            return false
        elseif entry.text:find("Checking [^ ]+ v%d+%.%d+%.%d+") then
            return false
        else
            return true
        end
    end)

    vim.fn.setqflist(new_qf)
end

function RustFoldText()
    return vim.fn.getline(vim.v.foldstart)
end

function RustFoldExpr()
    local current_found = vim.fn.getline(vim.v.lnum):find("^[^|]")
    if current_found then return ">1" end -- start a new fold

    local next_found = vim.fn.getline(vim.v.lnum + 1):find("^[^|]")
    if next_found then return "<1" end -- end the fold

    return "1" -- else, this line is in the current fold
end

vim.cmd [[
augroup RustQuickfix
    autocmd!
    autocmd QuickFixCmdPost make lua RustQuickfix()
    autocmd BufReadPost quickfix lua RustQuickfix()
    autocmd BufReadPost quickfix setlocal foldlevel=0
    autocmd BufReadPost quickfix setlocal foldtext=v:lua.RustFoldText()
    autocmd BufReadPost quickfix setlocal foldmethod=expr
    autocmd BufReadPost quickfix setlocal foldexpr=v:lua.RustFoldExpr()
    autocmd BufReadPost quickfix setlocal fillchars=fold:\ 
    autocmd BufReadPost quickfix setlocal textwidth=0
    autocmd BufReadPost quickfix nnoremap <buffer> = za
augroup END
]]
