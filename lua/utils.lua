local M = {}

---@type fun(s: string, ...: any)
M.printf = function(s, ...) return print(s:format(...)) end

M.printi = function(t) return print(vim.inspect(t)) end

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

---@diagnostic disable-next-line:lowercase-global
printi = M.printi; printf = M.printf

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
