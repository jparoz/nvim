" =============================================================================
" Filename: autoload/lightline/colorscheme/seethru.vim
" Author: jparoz
" License: MIT License
" Last Change: 2023/02/12 21:50:15.
" =============================================================================

let s:c00 = [ "#000000", 00 ]
let s:c01 = [ "#000000", 01 ]
let s:c02 = [ "#000000", 02 ]
let s:c03 = [ "#000000", 03 ]
let s:c04 = [ "#000000", 04 ]
let s:c05 = [ "#000000", 05 ]
let s:c06 = [ "#000000", 06 ]
let s:c07 = [ "#000000", 07 ]
let s:c08 = [ "#000000", 08 ]
let s:c09 = [ "#000000", 09 ]
let s:c10 = [ "#000000", 10 ]
let s:c11 = [ "#000000", 11 ]
let s:c12 = [ "#000000", 12 ]
let s:c13 = [ "#000000", 13 ]
let s:c14 = [ "#000000", 14 ]
let s:c15 = [ "#000000", 15 ]

let s:p = {'normal': {}, 'inactive': {}, 'command': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.insert.left     = [ [ s:c00, s:c02, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.replace.left    = [ [ s:c00, s:c09, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.visual.left     = [ [ s:c00, s:c05, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.command.left    = [ [ s:c00, s:c06, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.normal.left     = [ [ s:c00, s:c04, "bold,italic" ], [ s:c15, s:c08 ] ]
let s:p.normal.right    = [ [ s:c00, s:c07         ], [ s:c15, s:c08 ] ]
let s:p.normal.middle   = [ [ s:c15, s:c00         ] ]

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
