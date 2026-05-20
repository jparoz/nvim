# Smart Split Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local Neovim plugin that automatically adjusts new split orientation using configurable heuristics and blocklists.

**Architecture:** Keep decision logic in pure Lua functions so it is easy to test. Use a small `WinNew` autocmd wrapper to gather window context and apply the configured movement strategy.

**Tech Stack:** Neovim Lua, headless Neovim test script, existing local config module layout.

---

### Task 1: Decision Logic Tests

**Files:**
- Create: `tests/smart_split_spec.lua`
- Create: `tests/minimal_init.lua`

- [ ] Write tests for config defaults, blocklist matching, vertical/horizontal/unchanged decisions, and movement command selection.
- [ ] Run `nvim --headless -u tests/minimal_init.lua -c "luafile tests/smart_split_spec.lua" -c qa` and confirm it fails because `smart_split` does not exist.

### Task 2: Smart Split Module

**Files:**
- Create: `lua/smart_split/init.lua`

- [ ] Implement `setup`, config merging, `should_ignore`, `decide_orientation`, `movement_commands`, and the `WinNew` autocmd.
- [ ] Run the headless test command and confirm it passes.

### Task 3: Config Wiring

**Files:**
- Create: `lua/plugins/smart_split.lua`

- [ ] Add a lazy spec for the local plugin using `dir = vim.fn.stdpath("config")`.
- [ ] Configure default blocklists and `move = "rotate_or_exchange"`.
- [ ] Run the headless test command again.
