# 13 — UI & Appearance

**Files:** `lua/custom/plugins/no-clown-fiesta.lua`, `lua/custom/plugins/snacks.lua`,
`lua/custom/plugins/mini.lua`, `lua/custom/plugins/which-key.lua`,
`lua/custom/plugins/nvim-colorizer.lua`, `lua/custom/plugins/indent_line.lua`,
`lua/custom/plugins/express_line.lua`

---

## no-clown-fiesta (colorscheme)

```lua
'aktersnurra/no-clown-fiesta.nvim'
```

A restrained, low-saturation dark theme. The name says it all — it avoids the rainbow
explosion of many code themes. Syntax highlighting uses a limited, harmonious palette
that reduces eye strain during long sessions.

Options you can tweak in `no-clown-fiesta.lua`:
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

`snacks.nvim` is a collection of small, well-crafted plugins by folke. You now have
these modules enabled:

### image

Enables image rendering directly in Neovim buffers. This is especially powerful in
Markdown files.

*   **Inline images:** Renders image links `![]()` as actual images in the buffer.
*   **Mermaid diagrams:** Renders Mermaid code blocks as diagrams (if mermaid-cli is available).
*   **Performance:** Configured to `only_render_at_cursor = true` to maintain responsiveness.

> [!TIP]
> Ensure `conceallevel = 2` is set in your `init.lua` to see the rendered images and diagrams
> without the markdown syntax cluttering the view.

### notifier

Replaces `vim.notify` with a non-blocking notification system. Notifications appear
in the top-right corner, stack, and fade away.

*   `<leader>sN` — Open notification history.
*   `<leader>nd` — Dismiss all current notifications.

### statuscolumn

An enhanced status column (left gutter) with better formatting of line numbers, signs,
and fold indicators. It creates a much cleaner look than the default Neovim gutter.

### quickfile & bigfile

*   **quickfile**: Speeds up opening files by bypassing startup overhead.
*   **bigfile**: Automatically disables expensive features (Treesitter, LSP) for files over 1.5MB to prevent lag.

### Modules currently disabled

*   **words**: Highlighting word under cursor is currently **disabled** (`enabled = false`).
*   **scroll**: Smooth scrolling is **disabled** to maintain a snappy, instant feel.
*   **indent**: Snacks' indent guides are disabled in favor of `indent-blankline.nvim`.

---

## Statusline

You have two statusline options available:

### express_line.nvim (Primary)

Located in `lua/custom/plugins/express_line.lua`. It provides a highly customizable
and performant statusline.

Current layout:
`[MODE] [GIT BRANCH] [FILENAME] | [FILETYPE] [LINE:COL]`

### mini.statusline (Alternative)

Located in `lua/custom/plugins/mini.lua`. A clean, minimal statusline that serves as a
solid fallback or lightweight alternative.

---

## mini.nvim

### mini.ai (textobjects)

Extends Vim's built-in `i`/`a` textobjects with smarter versions:
- `ib` / `ab` — inside/around any bracket type (auto-detects `()`, `[]`, `{}`)
- `iq` / `aq` — inside/around any quote type (`'`, `"`, `` ` ``)
- `in)` — inside the *next* `(...)` after cursor.
- `il` / `al` — inside/around last bracket/quote.

### vim-surround

Managed via `tpope/vim-surround` (in `surround.lua`). Adds, deletes, and changes
surrounding pairs.

| Keymap | Action | Example |
|--------|--------|---------|
| `ys{motion}{char}` | Add surround | `ysiw"` → adds `"` around word |
| `ds{char}` | Delete surround | `ds"` → removes `"` |
| `cs{old}{new}` | Replace surround | `cs"'` → changes `"` to `'` |
| `S{char}` | Visual surround | Select text, `S"` → adds `"` |

---

## which-key.nvim

Shows a popup listing available keybindings. The delay is set to `0` for instant feedback.

Key groups defined in `which-key.lua`:
*   `<leader>c` — [C]ode
*   `<leader>d` — [D]ocument
*   `<leader>s` — [S]earch
*   `<leader>g` — [G]it
*   `<leader>i` — [I]mage
*   `<leader>m` — [M]arkdown
*   `<leader>t` — [T]oggle / Trouble

---

## Indent Guides

Indent guides are provided by `indent-blankline.nvim` (in `indent_line.lua`).

*   **Scope:** Shows the current indentation scope with a visible line.
*   **Disabled in:** Help, Alpha, Neo-tree, and other utility windows to reduce visual noise.

---

## Practical exercises

1.  **View an image:** Open a markdown file with an image link and move your cursor over it.
2.  **Toggle zen mode:** Press `<leader>z` for a distraction-free view (via `snacks.zen`).
3.  **Search marks:** Press `<leader>sm` to open the Snacks picker for marks.
4.  **Try mini.ai:** Use `vi)` to select inside parens, then `vib` to let it auto-detect the bracket type.
5.  **Which-key exploration:** Press `<leader>` and wait. Explore the `[M]arkdown` and `[I]mage` groups.
eader>s` for all search commands.
