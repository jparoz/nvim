vim.g.colors_name = "seethru"

local hi = function(group, opts)
    local cmd = "hi " .. group

    cmd = cmd .. " ctermfg=" .. (opts.fg or "NONE")
    opts.fg = nil

    cmd = cmd .. " ctermbg=" .. (opts.bg or "NONE")
    opts.bg = nil

    local any = false
    for k, v in pairs(opts) do
        if v then  -- i.e. if style `k` is true, e.g. reverse = true
            cmd = cmd .. " cterm=" .. k
            any = true
        end
    end
    if not any then
        cmd = cmd .. " cterm=NONE"
    end

    vim.cmd(cmd)
end


-- Quickfix
hi("QuickFixLine", {fg = 3})

-- Faded
hi("ColorColumn", {bg = 0})
hi("FoldColumn", {})
hi("Folded", {fg = 7})
hi("LineNr", {fg = 8})
hi("NonText", {fg = 8})
hi("SignColumn", {})
hi("SpecialKey", {fg = 8})
hi("StatusLine", {fg = 0, bg = 0})
hi("StatusLineNC", {fg = 0, bg = 0})
hi("WinSeparator", {fg = 0, bg = 0})
hi("Virtual", {fg = 8, italic = true})

-- Highlighted
hi("String", {fg = 15})
hi("Comment", {fg = 6})
hi("CursorColumn", {bg = 0})
hi("CursorLineNr", {fg = 7})
hi("CursorLine", {})
hi("Cursor", {reverse = true})
hi("Directory", {fg = 4})
hi("ErrorMsg", {fg = 9})
hi("Error", {fg = 9, italic = true})
hi("WarningMsg", {fg = 3, italic = true})
hi("Warning", {fg = 3, italic = true})
hi("MatchParen", {fg = 4, reverse = true})
hi("ModeMsg", {fg = 10})
hi("MoreMsg", {fg = 10})
hi("PmenuSel", {fg = 0, bg = 5})
hi("Question", {fg = 10})
hi("Search", {fg = 11, reverse = true})
hi("IncSearch", {reverse = true})
hi("Todo", {fg = 3})

-- Reversed
hi("PmenuSbar", {reverse = true})
hi("Pmenu", {reverse = true})
hi("PmenuThumb", {reverse = true})
hi("TabLineSel", {bold = true})
hi("Visual", {bg = 8})
hi("WildMenu", {reverse = true})

-- Diff
hi("DiffAdd", {fg = 10})
hi("DiffChange", {fg = 11})
hi("DiffDelete", {fg = 9})
hi("DiffText", {fg = 4})

-- Spell
hi("SpellBad", {underline = true})
hi("SpellCap", {})
hi("SpellLocal", {fg = 5, underline = true})
hi("SpellRare", {fg = 5, underline = true})

-- Vim Features
hi("Menu", {})
hi("Scrollbar", {})
hi("TabLineFill", {reverse = true})
hi("TabLine", {})
hi("Tooltip", {})

-- Floating windows
hi("NormalFloat", {})
-- FloatBorder
-- FloatShadow
-- FloatShadowThrough

-- Syntax Highlighting (or lack of)
hi("Boolean", {})
hi("Character", {})
hi("Conceal", {})
hi("Conditional", {})
hi("Constant", {})
hi("Debug", {})
hi("Define", {})
hi("Delimiter", {})
hi("Directive", {})
hi("Exception", {})
hi("Float", {})
hi("Format", {})
hi("Function", {})
hi("Identifier", {})
hi("Ignore", {})
hi("Include", {})
hi("Keyword", {})
hi("Label", {})
hi("Macro", {})
hi("Number", {})
hi("Operator", {})
hi("PreCondit", {})
hi("PreProc", {})
hi("Repeat", {})
hi("SpecialChar", {})
hi("SpecialComment", {})
hi("Special", {})
hi("Statement", {})
hi("StorageClass", {})
hi("Structure", {})
hi("Tag", {})
hi("Title", {})
hi("Typedef", {})
hi("Type", {})
hi("Underlined", {})

-- Sneak
hi("SneakPluginScope", {})
hi("SneakStreakMask", {fg = 0, bg = 10})
hi("SneakStreakStatusLine", {fg = 0, bg = 10})
hi("SneakStreakTarget", {fg = 0, bg = 2})

-- Dirvish
hi("DirvishSuffix", {fg = 8})

-- LSP
hi("DiagnosticError", {fg = 9})
hi("DiagnosticWarn", {fg = 3})
hi("DiagnosticInfo", {fg = 3})
hi("DiagnosticHint", {fg = 3})

hi("DiagnosticVirtualTextError", {fg = 8, italic = true})
hi("DiagnosticVirtualTextWarn", {fg = 8, italic = true})
hi("DiagnosticVirtualTextInfo", {fg = 8, italic = true})
hi("DiagnosticVirtualTextHint", {fg = 8, italic = true})
