# 13 — UI & Appearance

**Files:** `lua/custom/plugins/no-clown-fiesta.lua`, `lua/custom/plugins/snacks.lua`,
`lua/custom/plugins/mini.lua`, `lua/custom/plugins/which-key.lua`,
`lua/custom/plugins/nvim-colorizer.lua`, `lua/kickstart/plugins/indent_line.lua`

---

## no-clown-fiesta (colorscheme)

```lua
'aktersnurra/no-clown-fiesta.nvim'
```

A restrained, low-saturation dark theme. The name says it all — it avoids the rainbow
explosion of many code themes. Syntax highlighting uses a limited, harmonious palette
that reduces eye strain during long sessions.

Options you can tweak:
```lua
require('no-clown-fiesta').setup {
  theme = 'dark',       -- 'dark', 'dim', or 'light'
  transparent = false,  -- true for transparent terminal background
  styles = {
    comments = { italic = true },  -- italicise comments
    functions = { bold = true },   -- bold function names
    keywords = {},
    -- other categories: lsp, match_paren, type, variables
  },
}
```

---

## Snacks.nvim — the full picture

snacks.nvim is a collection of small, well-crafted plugins by folke. You now have
these modules enabled:

### notifier

Replaces `vim.notify` with a non-blocking notification system. Notifications appear
in the top-right corner, stack, fade away. `<leader>sN` opens history of all
notifications in the session.

`<leader>nd` — dismiss all current notifications.

> **Why it matters:** With the default `vim.notify`, error messages during async
> operations can appear at the bottom of the screen and be missed. The notifier makes
> them impossible to miss while not blocking your workflow.

### words

Highlights all occurrences of the word under cursor throughout the buffer, updated as
you move. This is similar to the LSP document highlight feature but works even without
an LSP and is instant. The two features stack in practice.

### scroll

Smooth scrolling is currently **disabled** (`enabled = false`) in your config
to maintain a snappy, instant feel during navigation. If you want animated
transitions for `<C-d>`, `<C-u>`, etc., you can enable this in `snacks.lua`.

### statuscolumn

An enhanced status column (left gutter) with better formatting of line numbers, signs,
and fold indicators. Works in concert with gitsigns and diagnostics for a cleaner left
margin.

### quickfile

Speeds up opening files by bypassing some Neovim startup overhead for single-file
invocations (`nvim myfile.go`).

### bigfile

Automatically disables expensive features (treesitter, LSP, syntax highlighting, spell
check) for files over a size threshold (1.5MB).

### lazygit (`<leader>gg`)

Opens lazygit in a floating terminal. Requires lazygit to be installed. A full
terminal UI for git — staging hunks, writing commit messages, viewing history,
rebasing, all in one place.

### zen mode (`<leader>z`)

Centres the current buffer in a clean, distraction-free view. Hides the statusline,
sign column, and surrounding splits. Good for writing markdown or prose.

---

## mini.nvim

You load three mini modules:

### mini.ai (textobjects)

```lua
require('mini.ai').setup { n_lines = 500 }
```

Extends Vim's built-in `i`/`a` textobjects with smarter versions:
- `ib` / `ab` — inside/around any bracket type (auto-detects `()`, `[]`, `{}`)
- `iq` / `aq` — inside/around any quote type (`'`, `"`, `` ` ``)
- Works across multiple lines (up to `n_lines = 500` lines)
- `in)` — inside the *next* `(...)` after cursor (not the one you're in)
- `il` / `al` — inside/around last bracket/quote

### vim-surround

```lua
require('vim-surround') -- Installed via tpope/vim-surround
```

Adds, deletes, and changes surrounding pairs. Default keymaps:

| Keymap | Action | Example |
|--------|--------|---------|
| `ys{motion}{char}` | Add surround | `ysiw"` → adds `"` around word |
| `ds{char}` | Delete surround | `ds"` → removes `"` |
| `cs{old}{new}` | Replace surround | `cs"'` → changes `"` to `'` |
| `S{char}` | Visual surround | Select text, `S"` → adds `"` |

Your markdown keymaps use this:
- `gss` (normal) → `ysiw\`` — surrounds current word with backticks (inline code)
- `gss` (visual) → `S\`` — surrounds selection with backtick

### mini.statusline

```lua
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function() return '%2l:%-2v' end
```

A clean, minimal statusline. The location section shows `LINE:COL` format.

---

## which-key.nvim

which-key shows a popup after a brief pause when you press a prefix key (like
`<leader>`), listing all completions with their descriptions.

```lua
delay = 0,  -- shows immediately when you pause
```

Your group definitions:
```lua
{ '<leader>c', group = '[C]ode' }
{ '<leader>d', group = '[D]ocument' }
{ '<leader>r', group = '[R]ename' }
{ '<leader>s', group = '[S]earch' }
{ '<leader>w', group = '[W]orkspace' }
{ '<leader>t', group = '[T]oggle / Trouble' }
{ '<leader>h', group = 'Git [H]unk' }
{ '<leader>q', group = '[Q]uickfix' }
{ '<leader>n', group = '[N]otifications' }
{ '<leader>g', group = '[G]it' }
```

---

## nvim-colorizer

```lua
'norcalli/nvim-colorizer.lua'
```

Colours hex codes and CSS colour names in-buffer. `#ff5733` appears with a background
of that colour. Useful when editing theme files, CSS, or any config with hex values.

---

## Indent Guides

Your configuration currently does **not** have active indent guides. Both
`indent-blankline.nvim` and `snacks.indent` are present in your plugin files but
are **disabled** or unconfigured by default.

To enable indent guides, you can set `enabled = true` in `lua/custom/plugins/snacks.lua`
under the `indent` module.

---

## Practical exercises

1. **Toggle zen mode:** Press `<leader>z` while editing a markdown file. Notice the
   distraction-free layout. Press again to return.

2. **Trigger the notifier:** Run `:lua vim.notify('Hello ' .. vim.fn.expand('%'), vim.log.levels.INFO)`.
   See it appear. Press `<leader>sN` to see notification history.

3. **Words highlight:** Move cursor over a variable name. Observe all occurrences in
   the buffer highlight. This is `snacks.words` layering with LSP document highlight.

4. **Try mini.ai:** In any file with nested brackets, press `vi)` to select inside
   parens, then try `vib` to auto-detect the bracket type. Try `vinq` to select inside
   the *next* quote.

5. **Which-key exploration:** Press `<leader>` and wait. Browse the groups. Explore
   `<leader>s` for all search commands.
