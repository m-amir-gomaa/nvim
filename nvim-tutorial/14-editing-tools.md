# 14 — Editing & Motion Tools

**Files:** `lua/custom/plugins/flash.lua`, `lua/custom/plugins/vim-visual-multi.lua`,
`lua/kickstart/plugins/autopairs.lua`, `lua/custom/plugins/outline.lua`,
`lua/custom/plugins/sleuth.lua`

---

## flash.nvim — jump anywhere

Flash gives you fast jump motions using labelled search. Instead of counting how many
`w` presses get you to a word, or typing `f` + character + `;;;;;`, you type two
characters and get a label on every match.

### Core motion: `s`

In normal mode, press `s` then type two characters. Every position on screen that
starts with those two characters gets a label (a single letter or letter pair). Type
the label to jump there.

Example: Press `s`, type `fn`. Every `fn` on screen gets a label. Type the label for
the function call you want. One jump, no counting.

### Treesitter select: `S`

`S` enters a mode where flash highlights *treesitter nodes*. Type characters to filter,
then select a node. The selection is syntactically aware — you can select entire
function bodies, argument lists, or expressions by filtering to where they start.

In visual and operator-pending mode, this is powerful:
- `vS` + select a function node → visually select that entire function
- `dS` + select a block node → delete that entire block

### Remote operations: `r`

In operator-pending mode, `r` means "perform this operation on a remote location."

- `yr{flash target}` — yank text at a remote location (without moving cursor)
- `dr{flash target}` — delete text at a remote location
- `cr{flash target}` — change text at a remote location

Example: You want to yank a function defined 50 lines down without navigating there.
Press `yr`, use flash to label the target, and the text is in your clipboard. Cursor
never moved.

### Treesitter search across buffers: `R`

In visual/operator-pending mode, `R` opens a search that spans all visible windows
and lets you select treesitter nodes anywhere on screen.

### Enhanced `f`/`F`/`t`/`T`

```lua
modes = { char = { enabled = true, jump_labels = true } }
```

The built-in `f` and `t` motions gain flash labels on repeat presses. When you press
`f` + character and there are multiple matches, they get labelled. Type the label to
jump directly.

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

1. **Flash jump:** Open a code file, press `s`, type the first two letters of any word
   you can see on screen, type the label that appears. Notice you jumped there instantly.

2. **Flash remote yank:** Press `yr`, then use flash to navigate to a word elsewhere in
   the file. Press the label. That word is now in your clipboard without your cursor
   moving.

3. **Multi-cursor rename:** Find a local variable in code, press `<C-n>` to select it,
   press `<C-n>` again for each occurrence, then `c` and type the new name.

4. **Outline navigation:** Open a file with many functions/classes. Press `<leader>o`
   and navigate the structure. Press `<CR>` to jump to a function definition.

5. **Test autopairs:** In a code file, type `func(` and observe the closing `)` appears.
   Type `"` and observe `""`. Try `<BS>` inside an empty `()`.
