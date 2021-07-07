local M = {}

M.printf = function(s, ...) return print(s:format(...)) end

M.printi = function(t) return print(vim.inspect(t)) end

M.each = function(t)
    local index = nil
    return function()
        local ix, nx = next(t, index)
        index = ix
        return nx
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
