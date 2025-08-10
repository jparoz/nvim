return { { "lifepillar/vim-mucomplete",

init = function()
    vim.opt.completeopt:append("menuone")
    vim.opt.shortmess:append("c")

    vim.cmd [[
        let g:mucomplete#can_complete = {}
    ]]

    -- Complete on :: in Rust
    vim.cmd [[
        let s:rust_cond = { t -> t =~# '\%(\i\|\|::\)$' }
        let g:mucomplete#can_complete.rust = { 'omni': s:rust_cond }
    ]]

    -- Complete on : in Lua
    vim.cmd [[
        let s:lua_cond = { t -> t =~# '\%(\i\|\|:\)$' }
        let g:mucomplete#can_complete.lua = { 'omni': s:lua_cond }
    ]]

    -- Complete on :: in C++
    vim.cmd [[
    let s:cpp_cond = { t -> t =~# '\%(\i\|\|::\)$' }
    let g:mucomplete#can_complete = {}
    let g:mucomplete#can_complete.cpp = { 'omni': s:cpp_cond }
    ]]

    -- Complete on . in Dart
    vim.cmd [[
        let s:dart_cond = { t -> t =~# '\%(\i\|\|\.\)$' }
        let g:mucomplete#can_complete.dart = { 'omni': s:dart_cond }
    ]]

    vim.g["mucomplete#chains"] = {
        default = {'omni', 'path', 'keyn', 'dict', 'uspl'},
        vim = {'path', 'cmd', 'keyn'},

        -- Having 'omni' and 'keyn' breaks the ordering for some reason.
        -- See https://github.com/lifepillar/vim-mucomplete/issues/180#issuecomment-939507716
        rust = {'omni', 'path', 'dict', 'uspl'},
    }

    -- Mappings
    vim.g["mucomplete#no_mappings"] = true
    vim.cmd [[imap <tab> <plug>(MUcompleteFwd)]]
    vim.cmd [[imap <s-tab> <plug>(MUcompleteBwd)]]
end,

} }
