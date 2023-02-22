" =============================================================================
" Filename: autoload/lightline/colorscheme/seethru.vim
" Author: jparoz
" License: MIT License
" Last Change: 2023/02/12 21:50:15.
" =============================================================================

let s:colors = exists("g:colors") ? g:colors : []

let s:c00 = [ get(s:colors, 00, "#000000"), 00 ]
let s:c01 = [ get(s:colors, 01, "#111111"), 01 ]
let s:c02 = [ get(s:colors, 02, "#222222"), 02 ]
let s:c03 = [ get(s:colors, 03, "#333333"), 03 ]
let s:c04 = [ get(s:colors, 04, "#444444"), 04 ]
let s:c05 = [ get(s:colors, 05, "#555555"), 05 ]
let s:c06 = [ get(s:colors, 06, "#666666"), 06 ]
let s:c07 = [ get(s:colors, 07, "#777777"), 07 ]
let s:c08 = [ get(s:colors, 08, "#888888"), 08 ]
let s:c09 = [ get(s:colors, 09, "#999999"), 09 ]
let s:c10 = [ get(s:colors, 10, "#AAAAAA"), 10 ]
let s:c11 = [ get(s:colors, 11, "#BBBBBB"), 11 ]
let s:c12 = [ get(s:colors, 12, "#CCCCCC"), 12 ]
let s:c13 = [ get(s:colors, 13, "#DDDDDD"), 13 ]
let s:c14 = [ get(s:colors, 14, "#EEEEEE"), 14 ]
let s:c15 = [ get(s:colors, 15, "#FFFFFF"), 15 ]

let s:p = {'normal': {}, 'inactive': {}, 'command': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.insert.left     = [ [ s:c00, s:c02, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.replace.left    = [ [ s:c00, s:c09, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.visual.left     = [ [ s:c00, s:c05, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.command.left    = [ [ s:c00, s:c06, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.normal.left     = [ [ s:c00, s:c04, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.normal.right    = [ [ s:c00, s:c07                ], [ s:c15, s:c08 ] ]
let s:p.normal.middle   = [ [ s:c15, s:c00 ] ]

let s:p.normal.error    = [ [ s:c00, s:c01 ] ]
let s:p.normal.warning  = [ [ s:c00, s:c03 ] ]

let s:p.inactive.left   = [ [ s:c15, s:c08 ] ]
let s:p.inactive.middle = [ [ s:c15, s:c00 ] ]
let s:p.inactive.right  = [ [ s:c15, s:c08 ] ]

let s:p.tabline.tabsel  = [ [ s:c07, s:c08 ] ]
let s:p.tabline.left    = copy(s:p.normal.middle)
let s:p.tabline.middle  = copy(s:p.normal.middle)
let s:p.tabline.right   = copy(s:p.normal.middle)

let g:lightline#colorscheme#seethru#palette = lightline#colorscheme#flatten(s:p)
