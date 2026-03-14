# 01 — Core Options & `init.lua`

**File:** `init.lua`

---

## What this file does

`init.lua` is the entry point for your entire Neovim configuration. It does three things:
sets global options, bootstraps lazy.nvim (your plugin manager), and imports your plugin
modules. Everything else in your config flows from this file.

---

## Your options, explained one by one

```lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
```

**Leader key.** Space is the best leader because it's the largest key on the keyboard,
always reachable with either thumb, and not used by default Vim motions. `maplocalleader`
is used by some plugins for buffer-specific mappings (e.g. filetype plugins). Both being
Space is the standard modern choice.

> **Tip:** If you ever want to see _all_ your active keymaps, run `:nmap <Space>` in
> command mode. You'll see every `<leader>` binding that's been registered.

---

```lua
vim.g.have_nerd_font = true
```

This single flag gates icon rendering across which-key, neo-tree, mini.statusline,
telescope, and snacks. With it `false`, everything falls back to ASCII. Now that it's
`true`, you get proper Nerd Font icons everywhere.

---

```lua
vim.o.number = true
vim.o.relativenumber = true
```

**Hybrid line numbers.** The current line shows absolute number; all other lines show
distance. This is the optimal setup for vertical motions: `5j`, `12k`, `d7j` all become
instant reads. The only time you need absolute numbers is when someone says "error on
line 847" — and it's right there.

---

```lua
vim.o.mouse = 'a'
```

Mouse in all modes. This surprises people who come from a "real Vim users don't use mice"
background, but it's valuable for: resizing splits by dragging, clicking to position
cursor when pair-programming, and scrolling in terminal mode. You can still ignore the
mouse entirely — it doesn't interfere.

---

```lua
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
```

**System clipboard integration.** The `unnamedplus` register (`+`) maps to your system
clipboard. This means `y` copies to system clipboard and `p` pastes from it — no more
`"+y` / `"+p`. The `vim.schedule` wrapper defers this until after `UiEnter` to avoid
slow startup on some systems where the clipboard provider (xclip/wl-paste) takes a moment
to initialise.

> **Your markdown yank override** in `extra_keybindings_linkarzu.lua` intercepts `y` in
> visual mode for markdown files specifically, running prettier with `--prose-wrap never`
> before copying. This is elegant — clipboard still works normally everywhere else.

---

```lua
vim.o.undofile = true
```

**Persistent undo.** Undo history is written to disk (in `~/.local/share/nvim/undo/`).
This means you can close a file, re-open it tomorrow, and still undo. Combined with your
`undotree` plugin, this is a full time-travel system for your edits.

---

```lua
-- Restore cursor position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", { ... })
```

**Cursor Persistence.** This ensures that when you reopen a file, you're placed exactly
where you left off. It uses the `"` mark (last known position) and applies it
globally, unless the filetype is explicitly excluded (like `gitcommit`).

---

```lua
vim.o.ignorecase = true
vim.o.smartcase = true
```

**Smart search casing.** `/hello` matches `hello`, `Hello`, `HELLO`. But `/Hello` (capital
letter present) matches only `Hello`. This is almost always what you want. Override for
exact case with `\C` anywhere in the pattern: `/\Chello` is case-sensitive.

---

```lua
vim.o.signcolumn = 'yes'
```

Keeps the sign column (left gutter) always visible so the buffer doesn't shift left/right
when diagnostics or gitsigns appear. Small detail, big ergonomic win.

---

```lua
vim.o.updatetime = 250
```

**How long Neovim waits before triggering `CursorHold` events.** This controls:

- How fast LSP document highlights appear (the highlight-on-hover effect)
- How fast diagnostics update in the float
- How fast gitsigns updates after you stop typing

`250ms` is a good balance — responsive without hammering the LSP server.

> **Override:** Your `mappings.lua` file sets `vim.opt.updatetime = 50`. This override
> wins because it runs later. `50ms` makes Neovim extremely responsive for
> highlight-on-hover and diagnostics, but keep an eye on CPU usage if it feels laggy.

---

## blink.cmp

blink.cmp is a modern, high-performance completion engine written in Rust. It's
faster and more feature-complete than the older nvim-cmp.

- Faster fuzzy matching (native Rust implementation available)

```lua
vim.o.timeoutlen = 300
```

How long Neovim waits for the next key in a sequence (e.g. after pressing `<leader>`).
`300ms` is short — which-key pops up faster, but you have less time to type multi-key
sequences before Neovim gives up. If you find yourself accidentally triggering things,
raise this to `500`.

---

### scrolloff

```lua
vim.o.scrolloff = 10
```

Minimal number of screen lines to keep above and below the cursor. Set to 10. This
ensures that when you navigate, you always see some context around the current line
rather than hitting the absolute top or bottom of the viewport.

---

```lua
vim.o.splitright = true
vim.o.splitbelow = true
```

`:vsplit` opens to the right, `:split` opens below. This is the natural reading direction
and avoids the jarring left/top splits of old Vim defaults.

---

### list / listchars

```lua
vim.o.list = false
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
```

Controls the display of invisible characters. It is currently **disabled** (`false`)
by default to keep the UI clean. Your `init.lua` has `listchars` commented out:
`-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }`.
If you enable `list`, it will use whatever defaults Neovim has unless you uncomment
that line.

---

```lua
vim.o.inccommand = 'split'
```

**Live substitution preview.** When you type `:%s/foo/bar/g`, a split opens at the
bottom showing every line that will be changed, live, as you type. This is one of
Neovim's best features and easy to forget exists. Try it.

---

```lua
vim.o.confirm = true
```

Instead of `E37: No write since last change` errors, Neovim asks you a yes/no question.
Prevents accidental data loss when closing modified buffers.

---

## The diagnostic configuration

```lua
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}
```

Breaking this down:

- **`update_in_insert = false`** — Diagnostics don't update while you're typing. This
  prevents red underlines flickering on every keystroke mid-expression. They update when
  you leave insert mode.
- **`severity_sort = true`** — Errors appear before warnings in the diagnostics list.
- **`source = 'if_many'`** — The float shows which LSP/linter produced the diagnostic
  only if multiple sources are active. Keeps things clean when you only have one.
- **`underline = { severity = vim.diagnostic.severity.ERROR }`** — Only errors get
  underlines; warnings and hints get virtual text but no underline squiggle. Reduces
  visual noise.
- **virtual_text = true** — Diagnostic text appears as a ghost at the end of the line.
- **virtual_lines = false** — Diagnostic text appears on its own virtual line below
  the error. This is **disabled** by default but can be toggled if you prefer a
  more readable (though more space-intensive) layout.
- **`jump = { float = true }`** — When you press `[d`/`]d` to jump between diagnostics,
  the float automatically opens. You see the full message immediately without pressing
  `K` again.

> **Try this:** Switch `virtual_text` to `false` and `virtual_lines` to `true` for a
> week. Many people prefer seeing the message below the line — it doesn't shrink your
> code horizontally.

---

## The yank highlight autocommand

```lua
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})
```

Flashes the yanked region briefly in a highlight colour. Small but invaluable — you
always know exactly what you copied, and you can spot off-by-one errors in your yank
motions.

---

## lazy.nvim bootstrap

```lua
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
```

This only runs once, on first launch. After that, lazy.nvim is already on disk and this
is a fast `fs_stat` check. `--filter=blob:none` does a blobless clone — much faster for
large repos because it only fetches objects you actually need.

> **NixOS note:** On NixOS you probably never need this to run because your flake pins
> and pre-fetches lazy.nvim. The bootstrap is harmless though — it just won't fire.

---

## Practical exercises

1. **Explore options interactively:** `:options` opens a browsable window of every Vim
   option with current values and documentation. Try it.

2. **Test the inccommand:** Open any file with repeated text and type
   `:%s/the/THE/g` — watch the preview split.

3. **Test persistent undo:** Edit a file, save, close Neovim, reopen, and press `u`.
   Your undo history is still there.

4. **Inspect your listchars:** `:set list` toggles the visible whitespace characters.
   `:set nolist` turns it off again. Your config has `vim.o.list = true` by default.
