# 02 — Core Keymaps

**Files:** `lua/custom/keybindings/mappings.lua`, `init.lua` (window nav)

---

## Philosophy of your keymap layout

Your keymaps follow a clear pattern you've built over time:

- `<leader>` for commands that don't need to be instant
- Single keys / motions for things used constantly
- `<M-x>` (Alt) for insert-mode accessible commands
- `[P]` in descriptions marks your personal additions vs kickstart defaults

---

## Window navigation

```lua
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
```

These are in `init.lua` and use the tmux-compatible `<C-w><C-h>` form (works both with
and without tmux navigator). The `<C-hjkl>` pattern mirrors your normal hjkl movement
and makes split navigation feel like extended cursor movement.

> **All the `<C-w>` commands you probably don't use:**
>
> - `<C-w>=` — equalise all split sizes
> - `<C-w>_` / `<C-w>|` — maximise height / width
> - `<C-w>r` — rotate splits
> - `<C-w>x` — swap two splits
> - `<C-w>T` — move current split to a new tab
> - `<C-w>o` — close every split _except_ the current one

---

## Escape & search

```lua
map('i', 'jk', '<Esc>', { desc = 'Easy escape' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
```

`jk` exits insert mode. This is the most common escape remapping and works because `jk`
never appears in a natural typing sequence where you'd need both letters with a pause.

`<Esc>` in normal mode clears the search highlight — so after searching, one `<Esc>` press
cleans up the screen. This is also mapped in `mappings.lua` as `<leader>` clear, so you
have two ways to do the same thing (harmless).

---

## Yank improvements

```lua
map('n', 'Y', 'y$', { desc = '[P]Yank to end of line' })
```

By default `Y` is an alias for `yy` (yank whole line), which is inconsistent with `D`
(delete to end) and `C` (change to end). This makes `Y` consistent: yank from cursor
to end of line.

```lua
map('n', 'J', 'mzJ`z')
```

The built-in `J` joins the next line onto the current one, but moves your cursor to the
join point. `mzJ\`z`saves cursor position to mark`z`, joins, then restores. Your cursor
stays in place. Invisible improvement you'll only notice when it's missing.

---

## Search centering

```lua
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
```

After jumping to the next/previous search match, `zz` centres the screen on the match,
`zv` opens any fold containing the match. Without this you'd frequently find yourself
staring at a match that's at the very bottom or top of the screen.

---

## Visual mode line movement

```lua
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = '[P]Move line down in visual mode' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = '[P]Move line up in visual mode' })
```

Select lines in visual mode, then `J`/`K` to move the block up or down. `gv=gv`
re-selects the moved block and re-indents it. This is faster than cut-paste for
repositioning code blocks.

### Marks cleanup

```lua
map('n', '<leader>mZ', function()
  vim.cmd 'delmarks!'
  print 'All marks deleted.'
end, { desc = '[P]Delete all marks' })
```

Sometimes marks accumulate and clutter your `sm` picker. This nukes all global and
local marks in one go.

---

## Plugin toggles / utils

```lua
map('n', '<leader><leader>u', ':UndotreeToggle<CR>', { silent = true })
```

Note: Undotree is bound to `<leader><leader>u` (double-leader), not just `<leader>u`.
This avoids conflict with other single-leader bindings.

---

## Tab and buffer navigation

```lua
map('n', 'gtn', ':tabnext<CR>')
map('n', 'gtp', ':tabprev<CR>')
map('n', '<leader>tn', ':tabnew<CR>')

map('n', 'bn', ':bn<CR>')    -- next buffer
map('n', 'bp', ':bp<CR>')    -- previous buffer
map('n', 'b^', ':b#<CR>')    -- alternate (last) buffer
map('n', 'bk', ':bd<CR>')    -- kill/delete buffer
```

> **`b^` / `:b#` is underrated.** The `#` register holds the "alternate file" — the
> last buffer you were in before this one. Pressing `b^` acts like `cd -` in the shell.
> When you're bouncing between two files (e.g. a module and its test), this is faster
> than harpoon.

> **Tip:** `:buffers` shows all open buffers with their numbers. `:b3` jumps to buffer 3.
> `<C-^>` is the built-in alternate file toggle (same as `b^`).

---

## Quickfix navigation (new)

```lua
map('n', ']q', '<cmd>cnext<CR>')
map('n', '[q', '<cmd>cprev<CR>')
map('n', '<leader>qq', '<cmd>copen<CR>')
map('n', '<leader>qc', '<cmd>cclose<CR>')
```

The quickfix list is one of Vim's most powerful features and historically underused.
It's populated by: grep results, LSP references, compiler errors, `gitsigns.diffthis`,
and anything you send to it with `:cexpr` or `:caddexpr`.

> **Practical pattern:** Run `:Telescope live_grep`, find usages of a function, then
> press `<C-q>` to send _all results_ to the quickfix list. Now `]q`/`[q` navigates
> every usage without re-running the search.

---

## The `gl` visual motion

```lua
map('v', 'gl', '$h', { desc = '[P]Go to the end of the line' })
```

In visual mode, `$` selects to end of line including the newline character, which causes
issues with some operations. `$h` goes to end-of-line then one left, landing on the last
visible character. This is the correct "select to end of line content" motion.

---

## Task toggle

```lua
map('n', '<leader>x', function()
  local line = vim.api.nvim_get_current_line()
  if line:match '%[ %]' then
    line = line:gsub('%[ %]', '[x]')
  elseif line:match '%[x%]' then
    line = line:gsub('%[x%]', '[ ]')
  else
    local indent = line:match '^(%s*)'
    line = indent .. '- [x] ' .. line:gsub('^%s*', '')
  end
  vim.api.nvim_set_current_line(line)
end)
```

Three behaviours in one:

1. `[ ]` present → marks as done `[x]`
2. `[x]` present → unchecks back to `[ ]`
3. Neither → wraps the line in `- [x] ` format (adds a completed task)

See also `<M-x>` in `markdown.lua` for the more powerful version that moves completed
tasks to a `## Completed Tasks` heading.

---

## Rust keymaps (scoped)

```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function(ev)
    map('n', '<leader>cr', function() vim.cmd.RustLsp 'codeAction' end, ...)
    map('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, ...)
    map('n', '<Leader>dt', function() vim.cmd 'RustLsp testables' end, ...)
  end,
})
```

These are **buffer-local** — they only exist in Rust files and override `K` (hover)
specifically for Rust, which gets `rustaceanvim`'s richer hover with inline actions
instead of plain LSP hover. See `12-rust-workflow.md` for the full Rust section.

---

## The terminal toggle

```lua
map('n', '<leader>tt', toggle_float_term, { desc = '[T]oggle floating [T]erminal' })
map('t', '<leader>tt', toggle_float_term, { desc = '[T]oggle floating [T]erminal' })
```

A custom implementation in `mappings.lua` that creates a centered popup window. It
persists the buffer, so if you're running a process (like a build), you can toggle the
window away and the process keeps running. It works from both normal and terminal mode
with the same key.

---

## The `yd` diagnostic yank

```lua
vim.keymap.set('n', 'yd', function() ... end,
  { desc = '[P]Yank line and diagnostic to system clipboard' })
```

Found in `extra_keybindings_linkarzu.lua`. Copies the current line _plus_ all diagnostic
messages on it to your system clipboard — formatted nicely for pasting into a bug report
or asking an AI assistant for help. This is a genuinely useful convenience.

---

## The prettier markdown yank (`v` → `y`)

In `extra_keybindings_linkarzu.lua`, the `y` key in visual mode is overridden for
markdown files:

```lua
vim.keymap.set('v', 'y', function()
  if vim.bo.filetype ~= 'markdown' then
    vim.cmd 'normal! "+y'
    return
  end
  -- ... writes selection to temp file, runs prettier --prose-wrap never, copies result
end)
```

**Why this exists:** Markdown files have `proseWrap: always` in your prettier config,
which wraps lines at 80 chars. When you paste markdown text into Slack/Discord/a browser,
those hard-wrapped newlines appear as line breaks. Running `--prose-wrap never` removes
them, giving you clean flowing text. Smart.

---

## Practical exercises

1. **Test line moving:** Select 3 lines with `V`, then press `J` and `K` to move the
   block around.

2. **Use the alternate buffer:** Open two files, jump between them a few times, then
   press `b^` to snap back to the previous one.

3. **Quickfix workflow:** Run `:Telescope live_grep` for a term, press `<C-q>` on
   results, then use `]q` / `[q` to walk through every hit.

4. **Test the diagnostic yank:** Position on a line with an error, press `yd`, then
   paste into a terminal — you'll see the line + the full diagnostic message.
