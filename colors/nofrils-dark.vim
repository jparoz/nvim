" Name: No Frils Dark Colorscheme
" Author: robertmeta (on Github)
" URL: https://github.com/robertmeta/nofrils
" (see this url for latest release & screenshots)
" License: OSI approved MIT license
"
" Note: edited by jparoz

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "nofrils-dark"

if !exists("g:nofrils_strbackgrounds")
    let g:nofrils_strbackgrounds = 0
endif
if !exists("g:nofrils_heavycomments")
    let g:nofrils_heavycomments = 0
endif
if !exists("g:nofrils_heavylinenumbers")
    let g:nofrils_heavylinenumbers = 0
endif

" Baseline
" hi Normal term=NONE cterm=NONE ctermfg=255 ctermbg=235 gui=NONE guifg=#c5c8c6 guibg=#1d1f21

" Quickfix
hi QuickFixLine term=NONE cterm=NONE ctermfg=255 ctermbg=235 gui=NONE guifg=#f0c674 guibg=#1d1f21

" Faded
hi ColorColumn term=NONE cterm=NONE ctermfg=NONE ctermbg=236 gui=NONE guifg=NONE guibg=#282a2e
hi FoldColumn term=NONE cterm=NONE ctermfg=242 ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Folded term=NONE cterm=NONE ctermfg=242 ctermbg=NONE gui=NONE guifg=#707880 guibg=NONE
hi LineNr term=NONE cterm=NONE ctermfg=8 ctermbg=bg gui=NONE guifg=#373b41 guibg=bg
hi NonText term=NONE cterm=NONE ctermfg=242 ctermbg=NONE gui=NONE guifg=#373b41 guibg=NONE
hi SignColumn term=NONE cterm=NONE ctermfg=242 ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi SpecialKey term=NONE cterm=NONE ctermfg=242 ctermbg=NONE gui=NONE guifg=#373b41 guibg=NONE
hi StatusLine term=NONE cterm=NONE ctermfg=black ctermbg=fg gui=NONE guifg=#000000 guibg=#282a2e
hi StatusLineNC term=NONE cterm=NONE ctermfg=fg ctermbg=242 gui=NONE guifg=#000001 guibg=#282a2e
hi VertSplit term=NONE cterm=NONE ctermfg=black ctermbg=242 gui=NONE guifg=#000000 guibg=#282a2e
hi Virtual term=NONE cterm=NONE ctermfg=fg ctermbg=52 gui=italic guifg=#666666 guibg=NONE

" Highlighted
hi CursorColumn term=NONE cterm=NONE ctermfg=NONE ctermbg=black gui=NONE guifg=NONE guibg=#282a2e
hi CursorIM term=NONE cterm=NONE ctermfg=black ctermbg=4 gui=NONE guifg=black guibg=#00FFFF
hi CursorLineNr term=NONE cterm=NONE ctermfg=NONE ctermbg=black gui=NONE guifg=#707880 guibg=NONE
hi CursorLine term=NONE cterm=NONE ctermfg=NONE ctermbg=black gui=NONE guifg=NONE guibg=NONE
hi Cursor term=NONE cterm=NONE ctermfg=black ctermbg=4 gui=NONE guifg=bg guibg=fg
hi Directory term=NONE cterm=NONE ctermfg=69 ctermbg=NONE gui=NONE guifg=#81a2be guibg=NONE
hi ErrorMsg term=NONE cterm=NONE ctermfg=fg ctermbg=52 gui=NONE guifg=fg guibg=#5F0000
hi Error term=NONE cterm=NONE ctermfg=fg ctermbg=52 gui=italic guifg=#cc6666 guibg=bg
hi IncSearch term=NONE cterm=NONE ctermfg=black ctermbg=green gui=reverse guifg=NONE guibg=NONE
hi MatchParen term=NONE cterm=NONE ctermfg=15 ctermbg=4 gui=NONE guifg=#1d1f21 guibg=#5f5f87
hi ModeMsg term=NONE cterm=NONE ctermfg=69 ctermbg=NONE gui=NONE guifg=#b5bd68 guibg=NONE
hi MoreMsg term=NONE cterm=NONE ctermfg=69 ctermbg=NONE gui=NONE guifg=#b5bd68 guibg=NONE
hi PmenuSel term=NONE cterm=NONE ctermfg=black ctermbg=13 gui=NONE guifg=black guibg=#FF00FF
hi Question term=NONE cterm=NONE ctermfg=69 ctermbg=NONE gui=NONE guifg=#b5bd68 guibg=NONE
hi Search term=NONE cterm=NONE ctermfg=black ctermbg=6 gui=NONE guifg=#1d1f21 guibg=#f0c674
hi Todo term=NONE cterm=NONE ctermfg=10 ctermbg=NONE gui=NONE guifg=#f0c674 guibg=NONE
hi VisualNOS term=NONE cterm=NONE ctermfg=NONE ctermbg=69 gui=NONE guifg=NONE guibg=#5F87FF
hi WarningMsg term=NONE cterm=NONE ctermfg=fg ctermbg=52 gui=italic guifg=#f0c674 guibg=NONE

" Reversed
hi PmenuSbar term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE
hi Pmenu term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE
hi PmenuThumb term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE
hi TabLineSel term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=bold guifg=NONE guibg=NONE
hi Visual term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=#373b41
hi WildMenu term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE

" Diff
hi DiffAdd term=NONE cterm=NONE ctermfg=2 ctermbg=NONE gui=NONE guifg=#008000 guibg=NONE
hi DiffChange term=NONE cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#808000 guibg=NONE
hi DiffDelete term=NONE cterm=NONE ctermfg=1 ctermbg=NONE gui=NONE guifg=#800000 guibg=NONE
hi DiffText term=NONE cterm=NONE ctermfg=4 ctermbg=NONE gui=NONE guifg=#000080 guibg=NONE

" Spell
hi SpellBad term=NONE cterm=NONE ctermfg=13 ctermbg=NONE gui=underline guifg=NONE guibg=NONE guisp=NONE
hi SpellCap term=NONE cterm=NONE ctermfg=13 ctermbg=NONE gui=NONE guifg=NONE guibg=NONE guisp=NONE
hi SpellLocal term=underline cterm=underline ctermfg=13 ctermbg=NONE gui=underline guifg=#FF00FF guibg=NONE
hi SpellRare term=underline cterm=underline ctermfg=13 ctermbg=NONE gui=underline guifg=#FF00FF guibg=NONE

" Vim Features
hi Menu term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Scrollbar term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi TabLineFill term=NONE cterm=NONE ctermfg=fg ctermbg=242 gui=reverse guifg=fg guibg=NONE
hi TabLine term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Tooltip term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE

" Syntax Highlighting (or lack of)
hi Boolean term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Character term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Conceal term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Conditional term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Constant term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Debug term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Define term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Delimiter term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Directive term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Exception term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Float term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Format term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Function term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Identifier term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Ignore term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Include term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Keyword term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Label term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Macro term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Number term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Operator term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi PreCondit term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi PreProc term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Repeat term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi SpecialChar term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi SpecialComment term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Special term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Statement term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi StorageClass term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Structure term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Tag term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Title term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Typedef term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Type term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Underlined term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE

" Sneak
hi SneakPluginScope term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi SneakStreakMask term=NONE cterm=NONE ctermfg=black ctermbg=darkgreen gui=NONE guifg=black guibg=darkgreen
hi SneakStreakStatusLine term=NONE cterm=NONE ctermfg=black ctermbg=darkgreen gui=NONE guifg=black guibg=darkgreen
hi SneakStreakTarget term=NONE cterm=NONE ctermfg=black ctermbg=green gui=NONE guifg=black guibg=green

hi Normal term=NONE cterm=NONE ctermfg=255 ctermbg=235 gui=NONE guifg=#c5c8c6 guibg=#1d1f21
hi LineNr term=NONE cterm=NONE ctermfg=8 ctermbg=bg gui=NONE guifg=#373b41 guibg=bg
hi Comment term=NONE cterm=NONE ctermfg=135 ctermbg=NONE gui=NONE guifg=#8abeb7 guibg=NONE
hi String term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#ffffff guibg=NONE

" Dirvish
hi DirvishSuffix guifg=#b5b8b6 guibg=#1d1f21

" LSP
hi link DiagnosticsDefaultError Error
hi link DiagnosticsDefaultWarning WarningMsg
hi link DiagnosticsDefaultInformation WarningMsg
hi link DiagnosticsDefaultHint WarningMsg

hi link DiagnosticsVirtualTextError Virtual
hi link DiagnosticsVirtualTextWarning Virtual
hi link DiagnosticsVirtualTextInformation Virtual
hi link DiagnosticsVirtualTextHint Virtual

let g:terminal_color_0  = "#151515"
let g:terminal_color_1  = "#AC4142"
let g:terminal_color_2  = "#90A959"
let g:terminal_color_3  = "#F4BF75"
let g:terminal_color_4  = "#6A9FB5"
let g:terminal_color_5  = "#AA759F"
let g:terminal_color_6  = "#75BFAA"
let g:terminal_color_7  = "#D0D0D0"
let g:terminal_color_8  = "#505050"
let g:terminal_color_9  = "#D28445"
let g:terminal_color_10 = "#202020"
let g:terminal_color_11 = "#303030"
let g:terminal_color_12 = "#B0B0B0"
let g:terminal_color_13 = "#E0E0E0"
let g:terminal_color_14 = "#8F5536"
let g:terminal_color_15 = "#F5F5F5"
