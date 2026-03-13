# 06 — Telescope

**File:** `lua/custom/plugins/telescope.lua`

---

## What telescope is

Telescope is a fuzzy finder framework. It has a "picker" architecture — any list of
items (files, grep results, LSP symbols, git commits, keymaps, Vim help, buffers) can
be fed through the same fuzzy-search UI. You type, it filters, you confirm.

The UI has three panes: prompt (your search), results (filtered list), preview (content
of highlighted item). All configurable.

---

## Your pickers and keymaps

```lua
vim.keymap.set('n', '<leader>sf', builtin.find_files)
```

**File finder.** Uses `rg --files --hidden` (you configured this). Finds files by
name anywhere in the project, including hidden files like `.env`, but excluding `.git/`.

> **Tip:** Press `<C-t>` in the picker to open the file in a new tab, `<C-v>` for a
> vertical split, `<C-x>` for a horizontal split.

```lua
vim.keymap.set('n', '<leader>sg', builtin.live_grep)
```

**Live grep.** Searches file _contents_ with ripgrep, live as you type. Your config
adds `--hidden` and excludes `.git/`.

> **Key move:** Inside telescope (any search), press `<C-q>` to send all current results to the
> quickfix list. Then close telescope and use `]q` / `[q` to navigate every match.
> See the **Quickfix Power Moves** section below for what to do once results are in
> quickfix — specifically `:cdo` and `:cfdo` for project-wide operations.

```lua
vim.keymap.set('n', '<leader>sM', multi_grep)
```

**Multi-grep.** An enhanced grep picker that lets you scope your search to specific
files using a two-field prompt. The fields are separated by **at least two spaces**:

```
pattern  glob-filter
```

Note: This implementation is robust. It handles extra spaces and trims the glob pattern automatically.

Examples:

| Prompt                      | What it does                             |
| --------------------------- | ---------------------------------------- |
| `parseConfig`               | Grep everywhere (identical to live_grep) |
| `parseConfig  *.go`         | Grep only in Go files                    |
| `TODO  src/**/*.ts`         | Grep only in `src/` TypeScript files     |
| `deprecated  !**/vendor/**` | Grep everywhere except `vendor/`         |

The key difference from `live_grep`: ripgrep handles all the filtering and ranking,
so telescope's fuzzy sorter is intentionally disabled. Results are exactly what `rg`
returns.

---

## Configuration details

```lua
vimgrep_arguments = vimgrep_arguments  -- with --hidden --glob '!**/.git/*'
```

Your search tools are configured to skip the `.git/` directory entirely for performance and include hidden files.

### Performance Tuning

```lua
-- In init.lua
vim.o.updatetime = 250
vim.o.scrolloff = 8

-- In telescope.lua
debounce = 250
```

- **`updatetime`**: Set to 250ms to reduce background IO overhead and improve general responsiveness.
- **`scrolloff`**: Set to 8 to keep context without the "jittery" screen-shifting that occurs with higher values.
- **`debounce`**: In `multi_grep`, results update every 250ms while typing to keep the UI smooth in large projects.

---

## Quickfix power moves

The quickfix list is where grep results become actionable at scale. Once you've sent
results there with `<C-q>`, you have two commands that operate on every item at once.

### `:cdo` — run a command on every quickfix entry

`:cdo` executes an Ex command once per quickfix item (one per matched line).

The canonical workflow for **project-wide rename**:

```
1. <leader>sg          → live_grep for "old_function_name"
2. <C-q>               → send all matches to quickfix, close telescope
3. :cdo s/old_function_name/new_function_name/g | update
```

### `:cfdo` — run a command on every quickfix _file_

`:cfdo` runs once per file in the quickfix list, not once per match.

```vim
:cfdo %s/old/new/g | update    " substitute across the entire file
:cfdo norm gg=G                " re-indent entire file
```

### Clearing the Quickfix List

If you find yourself with too much "junk" in the list, you can empty it with this command:

```vim
:call setqflist([], 'r')
```

**Alternative (Shorter):**
```vim
:cexpr []
```

**Lua equivalent:**
```lua
:lua vim.fn.setqflist({}, 'r')
```

But remember: Telescope usually **replaces** your quickfix list every time you press `<C-q>`, so you don't strictly need to clear it manually before running a new search—it will just overwrite the old results!
