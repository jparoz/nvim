local M = {}

local namespace = vim.api.nvim_create_namespace("cpp_else_conditions")
local augroup = vim.api.nvim_create_augroup("cpp_else_conditions", { clear = true })

local inverse_operators = {
    ["=="] = "!=",
    ["!="] = "==",
    ["<="] = ">",
    [">="] = "<",
    ["<"] = ">=",
    [">"] = "<=",
}

local function trim(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function is_wrapped(text)
    if text:sub(1, 1) ~= "(" or text:sub(-1) ~= ")" then
        return false
    end

    local depth = 0
    local quote = nil
    local escaped = false

    for index = 1, #text do
        local char = text:sub(index, index)

        if quote then
            if escaped then
                escaped = false
            elseif char == "\\" then
                escaped = true
            elseif char == quote then
                quote = nil
            end
        elseif char == '"' or char == "'" then
            quote = char
        elseif char == "(" then
            depth = depth + 1
        elseif char == ")" then
            depth = depth - 1
            if depth == 0 and index < #text then
                return false
            end
        end
    end

    return depth == 0
end

local function strip_wrapping_parens(text)
    text = trim(text)

    while is_wrapped(text) do
        text = trim(text:sub(2, -2))
    end

    return text
end

local function scan_top_level_operators(text)
    local depth = 0
    local quote = nil
    local escaped = false
    local comparisons = {}
    local has_other_operator = false
    local comparison_candidates = { "==", "!=", "<=", ">=", "<", ">" }
    local other_candidates = {
        "&&",
        "||",
        "&",
        "|",
        "^",
        "+",
        "-",
        "*",
        "/",
        "%",
        "<<",
        ">>",
        "<=>",
    }

    for index = 1, #text do
        local char = text:sub(index, index)

        if quote then
            if escaped then
                escaped = false
            elseif char == "\\" then
                escaped = true
            elseif char == quote then
                quote = nil
            end
        elseif char == '"' or char == "'" then
            quote = char
        elseif char == "(" or char == "[" or char == "{" then
            depth = depth + 1
        elseif char == ")" or char == "]" or char == "}" then
            depth = depth - 1
        elseif depth == 0 then
            for _, operator in ipairs(other_candidates) do
                if text:sub(index, index + #operator - 1) == operator then
                    has_other_operator = true
                    break
                end
            end

            for _, operator in ipairs(comparison_candidates) do
                if text:sub(index, index + #operator - 1) == operator then
                    table.insert(comparisons, { index = index, operator = operator })
                    break
                end
            end
        end
    end

    return comparisons, has_other_operator
end

local function is_whole_condition_not(text)
    if text:sub(1, 1) ~= "!" or text:sub(2, 2) == "=" then
        return false
    end

    local rest = trim(text:sub(2))
    if rest == "" then
        return false
    end

    local comparisons, has_other_operator = scan_top_level_operators(rest)
    return #comparisons == 0 and not has_other_operator
end

local function negate_condition(condition)
    condition = strip_wrapping_parens(condition)

    if is_whole_condition_not(condition) then
        local rest = strip_wrapping_parens(condition:sub(2))
        return rest
    end

    local comparisons, has_other_operator = scan_top_level_operators(condition)
    -- Only rewrite one plain comparison. Anything involving top-level boolean,
    -- bitwise, arithmetic, shift, or spaceship operators falls back to !(expr).
    if #comparisons == 1 and not has_other_operator then
        local comparison = comparisons[1]
        local left = trim(condition:sub(1, comparison.index - 1))
        local right = trim(condition:sub(comparison.index + #comparison.operator))
        return ("%s %s %s"):format(left, inverse_operators[comparison.operator], right)
    end

    return "!(" .. condition .. ")"
end

local function get_node_text(node, bufnr)
    local text = vim.treesitter.get_node_text(node, bufnr, {})
    if type(text) == "table" then
        return table.concat(text, "\n")
    end

    return text
end

local function set_else_mark(bufnr, else_node, condition)
    local start_row = else_node:range()
    local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    if not line then
        return
    end

    vim.api.nvim_buf_set_extmark(bufnr, namespace, start_row, #line, {
        virt_text = { { " // " .. negate_condition(condition), "Virtual" } },
        virt_text_pos = "eol",
    })
end

local function parse_query(lang, query_text)
    if vim.treesitter.query.parse then
        return vim.treesitter.query.parse(lang, query_text)
    end

    return vim.treesitter.query.parse_query(lang, query_text)
end

local function first_node(capture)
    if type(capture) == "table" then
        return capture[1]
    end

    return capture
end

function M.update(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

    local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr, "cpp")
    if not ok_parser or not parser then
        return
    end

    local ok_query, query = pcall(parse_query, "cpp", [[
        (if_statement
          condition: (_) @condition
          alternative: (else_clause) @else)
    ]])
    if not ok_query then
        return
    end

    local tree = parser:parse()[1]
    if not tree then
        return
    end

    local capture_ids = {}
    for id, name in ipairs(query.captures) do
        capture_ids[name] = id
    end

    for _, captures in query:iter_matches(tree:root(), bufnr, 0, -1) do
        local condition_node = first_node(captures[capture_ids.condition])
        local else_node = first_node(captures[capture_ids["else"]])
        if condition_node and else_node then
            set_else_mark(bufnr, else_node, get_node_text(condition_node, bufnr))
        end
    end
end

function M.enable(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    M.update(bufnr)

    vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "InsertLeave" }, {
        group = augroup,
        buffer = bufnr,
        callback = function()
            M.update(bufnr)
        end,
    })
end

return M
