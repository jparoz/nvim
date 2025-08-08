vim.o.guifont = "Input Mono:h11:w-1"

vim.opt.linespace = 5

vim.g.neovide_cursor_animation_length = 0.01

vim.g.neovide_padding_top    = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right  = 10
vim.g.neovide_padding_left   = 10

vim.cmd [[cd ~]]

-- Fullscreen toggle
function ToggleFullscreen()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end

vim.keymap.set("n", "<F11>", ToggleFullscreen)
