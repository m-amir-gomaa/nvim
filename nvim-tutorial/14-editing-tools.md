# 14 — Editing & Motion Tools

**Files:** `lua/custom/plugins/vim-visual-multi.lua`, `lua/kickstart/plugins/autopairs.lua`,
`lua/custom/plugins/outline.lua`, `lua/custom/plugins/sleuth.lua`

---

## vim-visual-multi — multiple cursors

```lua
'mg979/vim-visual-multi'
```

Adds VS Code/Sublime-style multi-cursor editing.

### Core workflow

**`<C-n>`** — Start a selection. Press again to select the next occurrence of the
current word. `n` / `N` for next/previous. `q` to skip an occurrence, `Q` to remove
that cursor.

**`<C-Down>` / `<C-Up>`** — Add a cursor on the line below/above (column stays fixed).
Useful for editing aligned columns.

**`<Shift-Arrows>`** — Extend selection character by character.

### After selecting multiple locations

You're in "multi-cursor mode." Standard Vim operations apply to all cursors:
- `i` — insert mode at all cursors simultaneously
- `a` — append at all cursors
- `I` / `A` — insert/append at start/end of each selection
- `c` — change each selection
- `d` — delete each selection
- `.` — repeat last change at all cursors
- `y` — yank from each cursor
- `s` — substitute on each selection

**`[` / `]`** — Navigate between cursors.

### Practical use cases

1. Rename a variable that `<leader>rn` can't reach (e.g. in a string or comment):
   `<C-n>` on the name, keep pressing to select all, `c` and type the new name.

2. Add a comma after every item in a column:
   `<C-Down>` to create cursors on each line, `A,` to append at end of each.

3. Quote a list of unquoted strings:
   Select first item with `<C-n>`, select all, `I"` then `A"`.

---

## nvim-autopairs

```lua
'windwp/nvim-autopairs'
event = 'InsertEnter'
```

Automatically closes brackets, parentheses, and quotes when you type them. Types `(`
→ you get `()` with cursor between. Types `"` → `""`.

Smart features:
- Knows not to add a closing bracket if one already exists immediately after cursor
- Integrates with blink.cmp: when you confirm a completion that ends with `()`,
  cursor is placed between the parens
- `<BS>` in `()` with empty content deletes both brackets simultaneously

---

## outline.nvim

```lua
vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Toggle Outline' })
```

Opens a sidebar showing the symbol tree of the current file — functions, classes,
methods, variables from the LSP. Click or navigate to jump to any symbol.

**Inside the outline:**
- `<CR>` — jump to that symbol in the main buffer
- `o` — jump without closing outline
- `<C-space>` — hover documentation for the symbol
- `f` — fold/unfold
- `F` — fold all
- `E` — expand all
- `q` — close

**When to use outline vs `<leader>ds`:**
- `<leader>ds` (Telescope document symbols) — for fuzzy searching by symbol name
- Outline — for visually navigating the structure, especially when exploring unfamiliar code

---

## vim-sleuth

```lua
'tpope/vim-sleuth'
```

Automatically detects and sets `tabstop`, `shiftwidth`, and `expandtab` by looking at
the existing indentation in the file and nearby files. Works silently in the background.

Open a project that uses tabs → Neovim switches to tab mode. Open a file using 2-space
indentation → Neovim uses 2 spaces. No configuration needed.

> `guess-indent.nvim` (removed from your init.lua) did the same thing. vim-sleuth is
> the original and more battle-tested solution.

---

## Practical exercises

1. **Multi-cursor rename:** Find a local variable in code, press `<C-n>` to select it,
   press `<C-n>` again for each occurrence, then `c` and type the new name.

4. **Outline navigation:** Open a file with many functions/classes. Press `<leader>o`
   and navigate the structure. Press `<CR>` to jump to a function definition.

5. **Test autopairs:** In a code file, type `func(` and observe the closing `)` appears.
   Type `"` and observe `""`. Try `<BS>` inside an empty `()`.


---
[← Previous: UI & Appearance](13-ui-appearance.md) | [Home](README.md) | [Next: Search & Diagnostics →](15-16-search-diagnostics.md)
