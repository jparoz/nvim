local M = {}

printf = function(s, ...) return print(s:format(...)) end

printi = function(t) return print(vim.inspect(t)) end

M.lua2vim = function(name)
    vim.cmd(
"function! " .. name .. [[(...)
    return luaeval("]] .. name .. [[(_A)", a:000)
endfunc
]])
end

M.each = function(t)
    local index = nil
    return function()
        local ix, nx = next(t, index)
        index = ix
        return nx
    end
end

M.has = function(s)
    return vim.fn.has(s) == 1
end

M.keymap = function(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end

    if options.buffer then
        local buffer = options.buffer
        options.buffer = nil
        vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, options)
    else
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end
end

return setmetatable(M, {
    __index = function(t, name)
        return function()
            if name == "inject" then
                for k, v in pairs(t) do
                    _G[k] = v
                end
                return true
            else
                return t[name]
            end
        end
    end,
})
