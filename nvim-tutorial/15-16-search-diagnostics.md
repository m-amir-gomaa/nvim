# 15 — Search & Replace

**Files:** `lua/custom/plugins/grug-far.lua`,
`lua/custom/keybindings/linkarzu_keybindings/extra_keybindings_linkarzu.lua`

---

## grug-far.nvim — project-wide search/replace

grug-far is a search-and-replace interface backed by ripgrep. It shows results live
as you type, lets you preview and approve replacements, and applies them atomically.

### Keymaps

| Key | Action |
|-----|--------|
| `<leader>s1` | Search/replace in current file only |
| `<leader>sv` | Search/replace within visual selection range |
| `<leader>sG` | Search/replace across entire project |

### Inside grug-far

The UI has fields for:
- **Search** — ripgrep pattern (supports full rg syntax: regex, fixed string, etc.)
- **Replace** — replacement text (supports capture groups from search)
- **Files filter** — restrict to specific globs (`*.go`, `src/**/*.ts`, etc.)
- **Path** — restrict to a subdirectory

Results appear live. Use the buffer like a normal buffer — navigate results, preview
context. Press the "Apply" action to execute all replacements.

**Ripgrep flags in search:** prefix your pattern with `--fixed-strings` for literal
matching, `-i` for case-insensitive, `--word-regexp` for whole words only.

---

## Inline substitute keymaps

These are in `extra_keybindings_linkarzu.lua`:

```lua
'<leader>su'   -- Replace word under cursor globally in file
'<leader>sU'   -- Replace word under cursor with UPPERCASE version
'<leader>sL'   -- Replace word under cursor with lowercase version
```

**`<leader>su`** sets up `:%s/\<current_word\>/current_word/gI` with the cursor
positioned before the flags, ready for you to edit the replacement text. The `\<...\>`
anchors match whole words only.

This is the fastest way to do a single-file rename — cursor on a word, `<leader>su`,
backspace the old word, type the new one, Enter.

---

# 16 — Diagnostics & Trouble

**Files:** `lua/custom/plugins/trouble.lua`, `init.lua` (diagnostic config)

---

## trouble.nvim

Trouble provides a structured panel for diagnostics, LSP references, quickfix items,
and location lists. Where the built-in quickfix list is minimal, Trouble is organised,
filterable, and integrated with your theme.

### Keymaps

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>td` | `Trouble diagnostics toggle` | All diagnostics across project |
| `<leader>tD` | `Trouble diagnostics toggle filter.buf=0` | Diagnostics in current buffer only |
| `<leader>ts` | `Trouble symbols toggle` | Symbol tree (like outline but in trouble) |
| `<leader>tl` | `Trouble lsp toggle` | LSP definitions + references in right panel |
| `<leader>tL` | `Trouble loclist toggle` | Location list |
| `<leader>tqf` | `Trouble qflist toggle` | Quickfix list with preview |

### Inside trouble

- `j` / `k` — navigate items
- `<CR>` — jump to the item's location
- `o` — jump and fold the trouble window
- `p` — preview item without jumping
- `q` or `<Esc>` — close trouble
- `r` — refresh
- `f` — filter/fold
- `?` — help

### Trouble vs Telescope for diagnostics

- **Telescope `<leader>sd`** — fuzzy-search through diagnostics, good for finding a
  specific error by message text
- **Trouble `<leader>td`** — persistent panel showing all diagnostics, updates live as
  you edit, good for working through a list methodically

---

## Diagnostic navigation (built-in)

These are Neovim built-ins, not plugins:

```
[d   -- jump to previous diagnostic
]d   -- jump to next diagnostic
```

Your config has `jump = { float = true }` which opens the float automatically on jump.

```
<leader>sd   -- Telescope: search diagnostics
K            -- show hover documentation (doubles as diagnostic detail when cursor is on error)
```

---

## Virtual text vs virtual lines

Your config:
```lua
virtual_text = true,
virtual_lines = false,
```

**Virtual text** — diagnostic message appears at the end of the error line as ghost
text. Compact but can overflow on long lines.

**Virtual lines** — message appears on a separate virtual line below the error line.
More readable for long messages, but takes screen space.

Try switching to `virtual_lines = true, virtual_text = false` for a session and see
which you prefer.

---



---
[← Previous: Editing Tools](14-editing-tools.md) | [Home](README.md) | [Next: Nix Tool Management →](17-nix-tool-management.md)
