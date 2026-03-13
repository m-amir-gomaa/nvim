# 19 — Floating Terminal

**File:** `lua/custom/plugins/terminal.lua`

---

## Overview

Neovim has a built-in terminal emulator — you don't need a plugin. The floating
terminal in your config builds on top of it with ~50 lines of Lua using
`vim.api.nvim_open_win` to create a centred floating window.

**Keymap:** `<leader>tt` — works from normal mode or from inside the terminal itself.

---

## How it works

```lua
<leader>tt  → first press:  opens a floating terminal window, enters insert mode
<leader>tt  → second press: hides the window (the shell keeps running)
<leader>tt  → third press:  re-opens it exactly where you left off
```

The terminal buffer persists across toggles. Hiding the window does not kill the
shell process — your working directory, history, and any running processes are all
still there when you re-open it. A new shell is only started the first time, or if
the previous process exits.

---

## Terminal mode

Neovim's terminal runs in a special mode called **terminal mode**. When the terminal
window opens, you're placed directly in insert mode so you can type commands
immediately.

To get back to normal Neovim (to navigate, copy output, etc.):

```
<Esc><Esc>   → exit terminal mode → normal mode
```

Once in normal mode inside the terminal buffer, all your usual Neovim motions work:
`j`/`k` to scroll, `/` to search output, `y` to yank text from the terminal output.

To go back to typing in the shell: press `i` or `a`.

---

## When to use the floating terminal

The floating terminal is useful for quick one-off commands where you don't want to
leave your editor context:

- Running a test for the file you're editing
- Checking `git log` or `git diff` without switching to lazygit
- Running a build or compile step
- Quick `rg` or `find` queries you don't want to do in Telescope

For longer-running shells (dev server, watch processes), a proper tmux split or a
separate terminal window is better — the floating terminal's buffer runs in Neovim's
process and will die if Neovim exits.

---

## Configuration details

```lua
local width  = math.floor(vim.o.columns * 0.85)  -- 85% of screen width
local height = math.floor(vim.o.lines   * 0.80)  -- 80% of screen height
```

The window is centred and takes up most of the screen, giving you room to read
command output comfortably. Adjust the multipliers in `terminal.lua` if you prefer
a smaller window.

```lua
border = 'rounded',
title  = '  Terminal  ',
```

Uses the same `rounded` border style as the rest of your UI (oil float, diagnostic
floats). The title confirms what the floating window is at a glance.

---

## Practical exercises

1. Press `<leader>tt`, run `ls -la`, press `<Esc><Esc>` to get to normal mode,
   yank a line of output with `yy`, close with `<leader>tt`.

2. Open a file, press `<leader>tt`, run `git diff HEAD`, scroll through the output
   in normal mode, close the terminal — observe you're back exactly where you were.

3. Run a long command (like `sleep 5 && echo done`), toggle the terminal closed with
   `<leader>tt`, keep editing, re-open with `<leader>tt` — the command finishes in
   the background and the output is there when you return.
