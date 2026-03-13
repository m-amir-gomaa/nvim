# 10 — File Navigation

**Files:** `lua/custom/plugins/harpoon.lua`, `lua/kickstart/plugins/neo-tree.lua`,
`lua/custom/plugins/oil.lua`, `lua/custom/plugins/marks.lua`

---

## Harpoon 2

Harpoon is a bookmark system for files. The idea: your brain holds about 4–6 files
at a time during any work session. Harpoon lets you pin those files and jump between
them instantly with a single keypress, without remembering buffer numbers or searching.

### Your configuration

```lua
settings = {
  save_on_toggle = true,    -- persist list when toggling the menu
  sync_on_ui_close = true,  -- sync to disk when UI closes
  key = function() return vim.loop.cwd() end,  -- separate lists per project
}
```

The `key` function is important: each project (CWD) gets its own harpoon list. Files
pinned in your Go project don't appear when you're in your Rust project.

### Keymaps

```lua
'<leader>a'    -- Add current file to harpoon list
'<leader>A'    -- Remove current file from harpoon list
'<C-e>'        -- Toggle the quick menu
'<leader>1-4'  -- Jump directly to harpoon slots 1-4
'<leader>p'    -- Go to previous file in list
'<leader>n'    -- Go to next file in list
```

**Inside the quick menu** (`<C-e>`):
- `<C-v>` — open file in vertical split
- `<C-x>` — open file in horizontal split
- `<C-t>` — open file in new tab
- Edit the list directly (it's a normal buffer) — reorder by moving lines
- Delete a file from the list by deleting its line

### Harpoon workflow

The intended pattern:
1. Open project, navigate to the 3–5 files you'll work with most
2. `<leader>a` on each to pin them
3. `<leader>1`, `<leader>2` etc. to teleport between them with zero friction
4. `<C-e>` to see and rearrange the list

### Replace at slot

```lua
'<leader><C-q>'   -- Replace slot 1 with current file
'<leader><C-w>'   -- Replace slot 2
'<leader><C-e>'   -- Replace slot 3
'<leader><C-r>'   -- Replace slot 4
```

Overwrites the existing file in a slot with your current buffer. Useful when your focus
shifts to different files mid-session.

### Extending harpoon

You have `harpoon_extensions.builtins.highlight_current_file()` — this highlights the
entry in the quick menu that corresponds to your current buffer. Subtle but useful visual
feedback.

---

## Neo-tree

**Keymap:** `<leader>e` opens neo-tree showing current file in the tree.

Neo-tree is a file explorer sidebar. Your config is minimal (default options). The things
most people miss:

**Navigation inside neo-tree:**
- `a` — create new file/directory
- `d` — delete
- `r` — rename
- `y` — copy filename to clipboard
- `Y` — copy relative path
- `<C-y>` — copy absolute path
- `m` — move file
- `c` — copy file
- `p` — paste (after copy/move)
- `s` — open file in vertical split
- `S` — open file in horizontal split
- `t` — open in new tab
- `i` — show file info (size, modified time)
- `H` — toggle hidden files
- `f` — fuzzy filter the current tree
- `R` — refresh the tree
- `?` — show all keymaps

**Closing:** `\` closes the window (configured in your opts).

### When to use neo-tree vs harpoon vs telescope

- **Harpoon** — for files you return to repeatedly during a session (your working set)
- **Telescope `<leader>sf`** — for finding a file by name anywhere in the project
- **Neo-tree** — for exploring an unfamiliar directory structure, creating new files,
  renaming, moving files around

---

## Oil.nvim

**Plugin:** `lua/custom/plugins/oil.lua` — `stevearc/oil.nvim`

Oil treats your filesystem as an editable buffer. Press `-` from any file and its
parent directory opens as a normal Neovim buffer. Filenames are just text — you use
the motions you already know to operate on them.

### Keymaps

| Key | Action |
|-----|--------|
| `-` | Open parent directory of current file |
| `<leader>-` | Open oil at the project CWD (root) |

### Inside an oil buffer

Oil looks like a file listing, but it's a live buffer. Everything you do to the text
becomes a filesystem operation when you save with `:w`.

| Key | Action |
|-----|--------|
| `<CR>` | Enter directory / open file |
| `-` | Go up to parent directory |
| `_` | Open the CWD |
| `<C-v>` | Open file in vertical split |
| `<C-x>` | Open file in horizontal split |
| `<C-t>` | Open file in new tab |
| `<C-p>` | Preview file without opening |
| `<C-r>` | Refresh the listing |
| `gs` | Change sort order |
| `gx` | Open file with system default app |
| `g.` | Toggle hidden files |
| `g?` | Show all keymaps |

### The mental model

```
# Rename a file:
  Navigate to it, press `r` to rename... no — just edit the line text
  Change "old-name.go" to "new-name.go", then :w

# Delete a file:
  dd (yes, literally delete the line), then :w

# Move a file:
  dd the line, navigate to the target directory (press - to go up, CR to enter),
  p to paste the line, then :w

# Create a file:
  Add a new line with the filename, then :w

# Create a directory:
  Add a new line ending with /, then :w
```

This is oil's core insight: you already know how to edit text in Neovim. File
management is just text editing applied to a directory buffer.

### Oil vs Neo-tree — which to reach for

**Oil** is faster for operations on files you're already near. You're editing
`src/auth/login.go`, you realise you need to rename it — press `-`, the directory
is right there, edit the name, `:w`, done. The motion was: one keypress to get to
the directory, one text edit, one save.

**Neo-tree** is better when you need to see the whole project tree at once, or when
you're in an unfamiliar codebase and want to explore the structure. It also has `f`
for fuzzy filtering the tree, which oil doesn't have.

Most people end up using both: oil for operations on nearby files, neo-tree for
orientation. Your config has both available — `-` and `<leader>e` coexist without
conflict.

---

## marks.nvim

**Plugin:** `lua/custom/plugins/marks.lua` — `chentoast/marks.nvim`

Marks are Vim's built-in way to save positions in files. `ma` sets mark `a`, `` `a ``
returns to it. `marks.nvim` adds:

- Visual indicators in the sign column showing where marks are
- `dm<letter>` — delete a specific mark
- `dm-` — delete all marks on the current line
- `:Marks` — Telescope picker of all marks
- `m,` — set the next available mark automatically (no need to choose a letter)
- `m;` — toggle the next mark and delete if already set

**Your keymap:**
```lua
map('n', '<leader>mZ', function() vim.cmd 'delmarks!' end)
```
Deletes all marks in the current buffer. Useful because marks.nvim's marks persist
across sessions and can accumulate.

### Mark types
- Lowercase letters (`a`–`z`) — buffer-local
- Uppercase letters (`A`–`Z`) — global, persist across files and sessions
- Numbers (`0`–`9`) — set automatically by Neovim from your history, read-only
- Special: `` `. `` — last edit position, `` `[ `` — start of last change,
  `` `] `` — end of last change, `` `< `` / `` `> `` — visual selection bounds

**Marks picker via Snacks:** `<leader>sm` (from your snacks config) opens a marks
picker. Faster than `:Marks` for navigating between marked positions.

---

## Undotree

**Plugin:** `lua/custom/plugins/undotree.lua`

```lua
keys = { { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" } }
```

Also mapped as `<leader><leader>u` in mappings.lua.

The undo tree visualises Neovim's branching undo history — not a linear list but a tree
of every state your buffer has ever been in. This plugin lets you navigate to *any*
historical state, even ones you overwrote by undoing and then typing something new.

**Inside undotree:**
- `u` — undo
- `<C-r>` — redo
- `<cr>` — jump to highlighted state
- `j` / `k` — move through tree

The combination of `undofile = true` (persistent undo) and undotree means you have
unlimited, persistent, non-linear edit history for every file.

---

## Practical exercises

1. **Full harpoon session:** Open a project, pin 3 files with `<leader>a`, then close
   and reopen those files using `<leader>1`, `<leader>2`, `<leader>3` only.

2. **Neo-tree workflow:** Press `<leader>e`, navigate to a directory, press `a` to
   create a new file, `r` to rename an existing one.

3. **Mark navigation:** Set mark `a` with `ma` on one line, go elsewhere in the file,
   set mark `b` with `mb`, then use `` `a `` and `` `b `` to jump between them. Open
   `<leader>sm` to see them in the marks picker.

4. **Explore undo tree:** Make a series of edits, undo a few, make different edits,
   then open the undotree with `<leader>u` — observe the branching structure and
   navigate to an old state.
