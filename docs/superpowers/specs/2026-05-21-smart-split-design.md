# Smart Split Design

## Goal

Create a local Neovim plugin that reacts when a new window is created and adjusts the split orientation using configurable heuristics.

## Behavior

The plugin applies to all non-floating windows by default, including help windows. Users can block windows by `filetype`, `buftype`, `bufname` pattern, or a custom predicate.

When a window is eligible, the plugin inspects the new window size, editor size, current layout column count, and visible buffer textwidths after Neovim has finished creating it. It decides whether the layout would be better as a vertical split, a horizontal split, or left unchanged.

The column limit can be fixed with `max_columns`, derived from textwidth, or clamped by `min_columns`. By default the textwidth calculation uses the largest non-zero textwidth among visible windows, falling back to `default_textwidth`; `textwidth_mode = "source"` instead uses the window that was active before `WinNew`.

## Movement Strategies

The movement strategy is configurable:

- `right`: use `wincmd L`, which is direct but can create a third column.
- `bottom`: use `wincmd J`, which is direct for horizontal layout changes.
- `respect_options`: use `wincmd L`/`H` and `wincmd J`/`K` according to the current `splitright` and `splitbelow` settings.
- `rotate_or_exchange`: prefer layout-preserving rotation or exchange commands before falling back to direct movement.
- function: accept a user callback for custom behavior.

The default is `respect_options`, because column-count heuristics now decide whether another vertical column is allowed before any movement happens.

## Configuration

The plugin exposes:

```lua
require("smart_split").setup({
    blocklist = {
        filetype = {},
        buftype = {},
        bufname = {},
        predicate = nil,
    },
    ignore = {
        commands = {
            "^%s*sp%s*.*$",
            "^%s*split%s*.*$",
            "^%s*vs%s*.*$",
            "^%s*vsplit%s*.*$",
            "^%s*vertical%s+.*$",
            "^%s*vert%l*%s+.*$",
            "^%s*horizontal%s+.*$",
            "^%s*hor%l*%s+.*$",
        },
        command_predicate = nil,
    },
    heuristics = {
        min_vertical_width = 100,
        min_horizontal_height = 30,
        min_horizontal_width = 80,
        min_columns = 2,
        max_columns = nil,
        default_textwidth = 80,
        textwidth_mode = "visible_max",
        prefer_vertical_after_columns = 2,
        wide_ratio = 1.8,
    },
    move = "respect_options",
    log = {
        level = "off",
        file = vim.fn.stdpath("state") .. "/smart_split.log",
        notify = false,
    },
})
```

## Testing

Tests cover option merging, blocklist matching, orientation decisions, and movement command selection. Neovim headless mode runs the Lua tests.
