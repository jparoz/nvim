return { { "lifepillar/vim-mucomplete",

init = function()
    vim.opt.completeopt:append("menuone")
    vim.opt.shortmess:append("c")

    -- Complete on :: in Rust
    vim.cmd [[
    let s:rust_cond = { t -> t =~# '\%(\i\|\|::\)$' }
    let g:mucomplete#can_complete = {}
    let g:mucomplete#can_complete.rust = { 'omni': s:rust_cond }
    ]]

    vim.g["mucomplete#chains"] = {
        default = {'omni', 'path', 'keyn', 'dict', 'uspl'},
        vim = {'path', 'cmd', 'keyn'},

        -- Having 'omni' and 'keyn' breaks the ordering for some reason.
        -- See https://github.com/lifepillar/vim-mucomplete/issues/180#issuecomment-939507716
        rust = {'omni', 'path', 'dict', 'uspl'},
    }
end,

} }
