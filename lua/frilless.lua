local Color, colors, Group, groups, styles = require("colorbuddy").setup()

vim.g.colors_name = "frilless"

local hex = {
    red         = "#AC4142",
    green       = "#90A959",
    khaki       = "#B5BD68",
    yellow      = "#F4BF75",
    blue        = "#6A9FB5",
    purple      = "#AA759F",
    pink        = "#DBA2BE",
    lavender    = "#5F5F87",
    teal        = "#8ABEB7",
    aqua        = "#75BFAA",
    orange      = "#D28445",
    brown       = "#8F5536",
    black       = "#151515",
    grey0       = "#202020",
    grey1       = "#282A2E",
    grey2       = "#373B41",
    grey3       = "#505050",
    grey4       = "#707880",
    grey5       = "#B0B0B0",
    grey6       = "#D0D0D0",
    grey7       = "#E0E0E0",
    white       = "#F5F5F5",

    fg0         = "#C5C6C8",
    bg0         = "#1D1F21",

    error       = "#CC6666",
    warning     = "#FFB470",

    diff_add    = "#008000",
    diff_change = "#808000",
    diff_delete = "#800000",
    diff_text   = "#000080",
}

for k, v in pairs(hex) do
    Color.new(k, v)
end

vim.g.terminal_color_0  = hex.black
vim.g.terminal_color_1  = hex.red
vim.g.terminal_color_2  = hex.green
vim.g.terminal_color_3  = hex.yellow
vim.g.terminal_color_4  = hex.blue
vim.g.terminal_color_5  = hex.purple
vim.g.terminal_color_6  = hex.aqua
vim.g.terminal_color_7  = hex.grey6
vim.g.terminal_color_8  = hex.grey3
vim.g.terminal_color_9  = hex.orange
vim.g.terminal_color_10 = hex.grey0
vim.g.terminal_color_11 = hex.grey2
vim.g.terminal_color_12 = hex.grey5
vim.g.terminal_color_13 = hex.grey7
vim.g.terminal_color_14 = hex.brown
vim.g.terminal_color_15 = hex.white


Group.new("Normal",     colors.fg0,     colors.bg0,     styles.NONE)

-- Quickfix
Group.new("QuickFixLine", colors.yellow, colors.bg, styles.NONE)

-- Faded
Group.new("ColorColumn", colors.none, colors.grey1, styles.NONE)
Group.new("FoldColumn", colors.none, colors.none, styles.NONE)
Group.new("Folded", colors.grey4, colors.none, styles.NONE)
Group.new("LineNr", colors.grey2, colors.bg, styles.NONE)
Group.new("NonText", colors.grey2, colors.none, styles.NONE)
Group.new("SignColumn", colors.none, colors.none, styles.NONE)
Group.new("SpecialKey", colors.grey2, colors.none, styles.NONE)
Group.new("StatusLine", colors.grey0, colors.grey1, styles.NONE)
Group.new("StatusLineNC", colors.black, colors.grey1, styles.NONE)
Group.new("VertSplit", colors.black, colors.grey1, styles.NONE)
Group.new("Virtual", colors.grey3, colors.none, styles.italic)

-- Highlighted
Group.new("String",     colors.white,   colors.none,    styles.NONE)
Group.new("Comment",    colors.teal,    colors.none,    styles.NONE)
Group.new("CursorColumn", colors.none, colors.grey1, styles.NONE)
-- Group.new("CursorIM", colors.black, colors.#00FFFF, styles.NONE)
Group.new("CursorLineNr", colors.grey4, colors.none, styles.NONE)
Group.new("CursorLine", colors.none, colors.none, styles.NONE)
Group.new("Cursor", colors.bg, colors.fg, styles.NONE)
Group.new("Directory", colors.blue, colors.none, styles.NONE)
Group.new("ErrorMsg", colors.none, colors.error, styles.NONE)
Group.new("Error", colors.error, colors.none, styles.italic)
Group.new("WarningMsg", colors.warning, colors.none, styles.italic)
Group.new("IncSearch", colors.none, colors.none, styles.reverse)
Group.new("MatchParen", colors.bg, colors.lavender, styles.NONE)
Group.new("ModeMsg", colors.khaki, colors.none, styles.NONE)
Group.new("MoreMsg", colors.khaki, colors.none, styles.NONE)
Group.new("PmenuSel", colors.black, colors.pink, styles.NONE)
Group.new("Question", colors.khaki, colors.none, styles.NONE)
Group.new("Search", colors.bg, colors.yellow, styles.NONE)
Group.new("Todo", colors.yellow, colors.none, styles.NONE)
-- Group.new("VisualNOS", colors.none, colors.#5F87FF, styles.NONE)

-- Reversed
Group.new("PmenuSbar", colors.none, colors.none, styles.reverse)
Group.new("Pmenu", colors.none, colors.none, styles.reverse)
Group.new("PmenuThumb", colors.none, colors.none, styles.reverse)
Group.new("TabLineSel", colors.none, colors.none, styles.bold)
Group.new("Visual", colors.none, colors.grey2, styles.NONE)
Group.new("WildMenu", colors.none, colors.none, styles.reverse)

-- Diff
Group.new("DiffAdd", colors.diff_add, colors.none, styles.NONE)
Group.new("DiffChange", colors.diff_change, colors.none, styles.NONE)
Group.new("DiffDelete", colors.diff_delete, colors.none, styles.NONE)
Group.new("DiffText", colors.diff_text, colors.none, styles.NONE)

-- Spell
Group.new("SpellBad", colors.none, colors.none, styles.underline)
Group.new("SpellCap", colors.none, colors.none, styles.NONE)
Group.new("SpellLocal", colors.pink, colors.none, styles.underline)
Group.new("SpellRare", colors.pink, colors.none, styles.underline)

-- Vim Features
Group.new("Menu", colors.none, colors.none, styles.NONE)
Group.new("Scrollbar", colors.none, colors.none, styles.NONE)
Group.new("TabLineFill", colors.fg, colors.none, styles.reverse)
Group.new("TabLine", colors.none, colors.none, styles.NONE)
Group.new("Tooltip", colors.none, colors.none, styles.NONE)

-- Syntax Highlighting (or lack of)
Group.new("Boolean", colors.none, colors.none, styles.NONE)
Group.new("Character", colors.none, colors.none, styles.NONE)
Group.new("Conceal", colors.none, colors.none, styles.NONE)
Group.new("Conditional", colors.none, colors.none, styles.NONE)
Group.new("Constant", colors.none, colors.none, styles.NONE)
Group.new("Debug", colors.none, colors.none, styles.NONE)
Group.new("Define", colors.none, colors.none, styles.NONE)
Group.new("Delimiter", colors.none, colors.none, styles.NONE)
Group.new("Directive", colors.none, colors.none, styles.NONE)
Group.new("Exception", colors.none, colors.none, styles.NONE)
Group.new("Float", colors.none, colors.none, styles.NONE)
Group.new("Format", colors.none, colors.none, styles.NONE)
Group.new("Function", colors.none, colors.none, styles.NONE)
Group.new("Identifier", colors.none, colors.none, styles.NONE)
Group.new("Ignore", colors.none, colors.none, styles.NONE)
Group.new("Include", colors.none, colors.none, styles.NONE)
Group.new("Keyword", colors.none, colors.none, styles.NONE)
Group.new("Label", colors.none, colors.none, styles.NONE)
Group.new("Macro", colors.none, colors.none, styles.NONE)
Group.new("Number", colors.none, colors.none, styles.NONE)
Group.new("Operator", colors.none, colors.none, styles.NONE)
Group.new("PreCondit", colors.none, colors.none, styles.NONE)
Group.new("PreProc", colors.none, colors.none, styles.NONE)
Group.new("Repeat", colors.none, colors.none, styles.NONE)
Group.new("SpecialChar", colors.none, colors.none, styles.NONE)
Group.new("SpecialComment", colors.none, colors.none, styles.NONE)
Group.new("Special", colors.none, colors.none, styles.NONE)
Group.new("Statement", colors.none, colors.none, styles.NONE)
Group.new("StorageClass", colors.none, colors.none, styles.NONE)
Group.new("Structure", colors.none, colors.none, styles.NONE)
Group.new("Tag", colors.none, colors.none, styles.NONE)
Group.new("Title", colors.none, colors.none, styles.NONE)
Group.new("Typedef", colors.none, colors.none, styles.NONE)
Group.new("Type", colors.none, colors.none, styles.NONE)
Group.new("Underlined", colors.none, colors.none, styles.NONE)

-- Sneak
Group.new("SneakPluginScope", colors.none, colors.none, styles.NONE)
Group.new("SneakStreakMask", colors.black, colors.darkgreen, styles.NONE)
Group.new("SneakStreakStatusLine", colors.black, colors.darkgreen, styles.NONE)
Group.new("SneakStreakTarget", colors.black, colors.green, styles.NONE)

-- Dirvish
Group.new("DirvishSuffix", colors.grey3, colors.bg, styles.NONE)

-- LSP
Group.new("LspDiagnosticsDefaultError", groups.Error, groups.Error, groups.Error)
Group.new("LspDiagnosticsDefaultWarning", groups.WarningMsg, groups.WarningMsg, groups.WarningMsg)
Group.new("LspDiagnosticsDefaultInformation", groups.WarningMsg, groups.WarningMsg, groups.WarningMsg)
Group.new("LspDiagnosticsDefaultHint", groups.WarningMsg, groups.WarningMsg, groups.WarningMsg)

Group.new("LspDiagnosticsVirtualTextError", groups.Virtual, groups.Virtual, groups.Virtual)
Group.new("LspDiagnosticsVirtualTextWarning", groups.Virtual, groups.Virtual, groups.Virtual)
Group.new("LspDiagnosticsVirtualTextInformation", groups.Virtual, groups.Virtual, groups.Virtual)
Group.new("LspDiagnosticsVirtualTextHint", groups.Virtual, groups.Virtual, groups.Virtual)
