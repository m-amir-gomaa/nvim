# 18 — Under the Hood: How Your Custom Code Actually Works

This file explains the actual Lua implementations behind your most complex keymaps.
Not the what — the _how_.

---

## The `<M-x>` task toggle: a state machine in 100 lines

This is the most sophisticated piece of Lua in your config. It handles three states and
moves multi-line chunks between sections of the file atomically.

### State detection

```lua
for i, line in ipairs(chunk) do
  chunk[i] = line:gsub('%[done:([^%]]+)%]', '`' .. label_done .. '%1`')
  chunk[i] = chunk[i]:gsub('%[untoggled%]', '`untoggled`')
  if chunk[i]:match('`' .. label_done .. '.-`') then
    has_done_index = i; break
  end
end
```

The first thing it does is **normalise** the chunk: any `[done: 250310-1430]` bracket
notation gets converted to backtick notation `` `done: 250310-1430` ``. Then it
searches for which label is present to determine state.

**State transitions:**

- `has_done_index` present → go to "untoggled" state
- `has_untoggled_index` present (but no done) → go back to "done" state
- Neither → first completion: mark done, move to `## Completed Tasks`

### Multi-line chunk detection

```lua
local chunk_end = start_line
while chunk_end + 1 < total_lines do
  local next_line = lines[chunk_end + 2]
  if next_line == '' or next_line:match '^%s*%-' then break end
  chunk_end = chunk_end + 1
end
```

A "chunk" is the bullet line plus all continuation lines — lines that aren't blank and
don't start a new bullet. This correctly handles:

```
- [ ] Write the tutorial
  This is a continuation line that explains the task
  Another continuation
- [ ] Next unrelated task    ← stops here
```

---

## NixOS Cross-Repo Sync: The Hard Link Strategy

### The Problem

Nix Flakes require all imported files to be physically inside the git repository. However, your Neovim config (`nvim`) and your NixOS environment (`NixOSenv`) are separate repositories.

1.  **Symlinks** fail because Nix sees the absolute path and blocks it in "pure" mode.
2.  **Rsync** requires a manual trigger.

### The Solution: Hard Linking

```bash
ln /home/qwerty/NixOSenv/nvim.nix /home/qwerty/nvimConfig/nvim.nix
```

A hard link makes the two files point to the same **inode** on the disk. To the operating system (and Nix), they are the exact same file.

- **Instant Sync**: Saving in `nvim-config` updates `NixOSenv` bit-for-bit immediately.
- **Pure Build**: Nix evaluates it as a local file, satisfying the "Pure Evaluation" safety checks.

---

## Standalone UML Previewer Architecture

While Snacks.nvim handles simple Mermaid diagrams, professional UML (PlantUML) requires a more robust engine and browser-based rendering for complex layouts.

### Workflow Logic

1.  **Buffer Identification**: `plantuml.lua` uses a `FileType` autocmd to detect `.puml` files.
2.  **Execution Stack**:
    - **aklt/plantuml-syntax**: Provides high-performance Vim-native highlighting.
    - **tyru/open-browser.vim**: Handles cross-platform "Open URL" logic.
    - **weirongxu/plantuml-previewer.vim**: The core engine.
3.  **Compilation Pipeline**:
    - When you run `:PlantumlOpen` (`<leader>dv`), the plugin calls the **`plantuml`** binary (provided by Nix + JDK).
    - It generates a temporary `.png` or `.svg`.
    - It generates a thin `viewer.html` and opens it using `open-browser`.
    - Subsequent saves trigger a background recomps and the HTML auto-refreshes using local polling or web sockets.

### NixOS Dependencies

Required in `nvim.nix`:

- `plantuml`: The diagram engine.
- `graphviz`: Required by PlantUML for non-trivial layouts.
- `jdk`: The Java environment required to run the PlantUML `.jar`.

### The move operation

When completing a task for the first time:

1. The chunk is removed from its current position with `table.remove`
2. The entire `lines` table is searched for `## Completed Tasks`
3. The chunk is inserted immediately after the heading (top of the completed list)
4. The window view is saved with `winsaveview` before and restored after — this is why
   your scroll position doesn't jump when you complete tasks

### The view preservation trick

```lua
vim.cmd 'mkview'
-- ... all modifications ...
vim.cmd 'loadview'
```

`mkview` saves the entire window state including folds. `loadview` restores it. Without
this, every time you complete a task, your markdown folds would collapse. This is the
correct way to preserve folds across buffer modifications.

---

## The URL extractor: balancing parentheses in regex-free Lua

```lua
local function rtrim_url(u)
  while u:match '[%)%]%}%.%,%;%:%?%!%\\'%\">%)]$' do
    u = u:sub(1, #u - 1)
  end
  local open_paren = select(2, u:gsub('%(', ''))
  local close_paren = select(2, u:gsub('%)', ''))
  if close_paren > open_paren and u:sub(-1) == ')' then u = u:sub(1, #u - 1) end
  return u
end
```

The URL extractor faces a real parsing problem: markdown link syntax is
`[text](https://url.com/path(with)parens)` — the URL can contain matched parentheses,
but the outer `)` closes the markdown link and shouldn't be part of the URL.

The solution:

1. Strip common trailing punctuation in a loop
2. Count open `(` vs close `)` in the remaining URL
3. If there are more closing parens than opening, the last `)` is the markdown closer,
   remove it

This is more correct than a simple regex and handles real-world URLs like Wikipedia
links which frequently contain `(` and `)` in their paths.

---

## The `gsu` URL surround: scanning with overlap

```lua
local s, e = string.find(line, pattern)
while s and e do
  if s <= col and e >= col then
    -- cursor is inside this URL
    local url = string.sub(line, s, e)
    local new_line = string.sub(line, 1, s - 1) .. '`' .. url .. '`' .. string.sub(line, e + 1)
    vim.api.nvim_set_current_line(new_line)
    return
  end
  s, e = string.find(line, pattern, e + 1)
end
```

`string.find` returns start and end indices. The loop advances by passing `e + 1` as
the search start. When a match straddles the cursor column (`s <= col <= e`), it
wraps that specific URL in backticks by slicing the line into three parts:

- `line[1..s-1]` — before the URL
- `` `url` `` — the URL in backticks
- `line[e+1..]` — after the URL

Note the `vim.cmd 'silent write'` call — it saves immediately so that trouble.nvim and
markdownlint pick up the change.

---

## The heading context system

```lua
local query = vim.treesitter.query.parse('markdown', [[
  (atx_heading (atx_h1_marker) @h1)
  (atx_heading (atx_h2_marker) @h2)
  ...
]])
for id, node in query:iter_captures(tree:root(), 0) do
  local start_line = node:start() + 1
  table.insert(headings, { line = start_line, level = id })
end
```

This is real treesitter query parsing. The `@h1`...`@h6` captures return `id` values
1–6 which directly represent heading level. The tree is parsed fresh on every call
(`parser:parse()[1]`), so edits are always reflected.

**Used by two keymaps:**

`<leader>mT` — notification showing current H-level + line, next heading, next
same-level heading. The "next same-level" part is useful when navigating between sibling
sections of a document.

`<C-CR>` (Emacs-style heading insert) — uses the same context to determine _where_ to
insert a new heading. Logic:

1. Get current heading level
2. Find `next_same_line` — the next heading at the same level
3. If a higher-level heading comes first, insert before that
4. Otherwise insert at `next_same_line` position
5. `nvim_buf_set_lines` inserts the new heading and blank line
6. Cursor positioned after the `## ` prefix, insert mode begins automatically

---

## The YouTube embed processor

```lua
local protected_sections = {
  ['YouTube video'] = true,
  ['Other videos mentioned'] = true,
}
-- Track which H2 section we're currently in
for i, line in ipairs(lines) do
  if line:match '^##%s+' then current_section = line:match '^##%s+(.-)%s*$' end
  if line:match '^{%% include embed/youtube.html' then
    if not protected_sections[current_section] then
      -- collect for moving
    end
  end
end
```

This is a Jekyll-specific tool. Your blog posts use `{% include embed/youtube.html id=... %}`
template tags. The processor:

1. Scans the file tracking which `##` section it's in
2. Collects all YouTube embeds that aren't already in protected sections
3. Removes them from their current positions
4. Creates or overwrites a `## Other videos mentioned` section above the
   `## If you like my content...` section
5. Deduplicates embeds (uses a `seen` table)

The `_Y` variant runs this on every `.md` file in the git repo using `io.popen` with
`find`, loading each with `vim.fn.bufadd` + `vim.fn.bufload`.

---

## The TOC system: view preservation with folds

```lua
vim.cmd 'mkview'
-- insert TOC markers if not present
vim.cmd 'silent write'
vim.fn.system('markdown-toc --bullets "-" -i ' .. path)
vim.cmd 'edit!'          -- reload from disk (markdown-toc wrote the TOC)
vim.cmd 'silent write'
vim.notify('TOC updated and file saved', vim.log.levels.INFO)
vim.cmd 'loadview'
```

The flow:

1. `mkview` — save fold state
2. Insert `## Contents`, `### Table of contents`, `<!-- toc -->` if not present
3. Write to disk (markdown-toc needs the current content)
4. Call `markdown-toc --bullets "-" -i <file>` — the `-i` flag edits in place
5. `edit!` — reload the buffer from disk (the file was changed by the external tool)
6. Write again (marks buffer as saved)
7. `loadview` — restore folds

The `<!-- toc -->` marker is how markdown-toc identifies where to insert/update. The
frontmatter detection finds the closing `---` to avoid inserting the TOC inside YAML.

---

## The bold toggle: bidirectional multiline search

The `<leader>mb` normal-mode bold toggle is the most complex string operation:

```lua
local left_text = line:sub(1, col)
local bold_start = left_text:reverse():find '%*%*'
if bold_start then bold_start = col - bold_start end
```

To find the opening `**` to the _left_ of cursor, it reverses the substring from line
start to cursor and searches from the beginning — this finds the _nearest_ `**` to the
left. The position is then translated back to the original coordinate system with
`col - bold_start`.

For the closing `**` to the right:

```lua
local right_text = line:sub(col + 1)
local bold_end = right_text:find '%*%*'
local end_row = start_row
while not bold_end and end_row < line_count - 1 do
  end_row = end_row + 1
  local next_line = vim.api.nvim_buf_get_lines(...)
  if next_line == '' then break end
  right_text = right_text .. '\n' .. next_line
  bold_end = right_text:find '%*%*'
end
```

It extends `right_text` line by line until it finds `**` or hits a blank line. This
correctly handles multiline bold like:

```
**This is a bold phrase
that spans two lines**
```

When both `**` markers are found, the text between them is extracted and the markers
removed. When neither is found, the word under cursor is bolded with `viw` + `2gsa*`.

---

## Spell repeat via feedkeys

```lua
vim.keymap.set('n', '<leader>msr', function()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(':spellr\n', true, false, true),
    'm', true
  )
end)
```

`:spellr` repeats the last `z=` spelling correction for all matching words in the window.
This is done via `nvim_feedkeys` rather than `vim.cmd 'spellr'` because `:spellr` needs
to run in a specific mode context. The `'m'` flag means "remap keys" (normal feedkeys
behaviour). `nvim_replace_termcodes` translates the `\n` to the actual Enter keycode.

---

## The `<M-l>` task bullet: three-way line analysis

```lua
-- Case 1: empty line
if line:match '^%s*$' then
  vim.api.nvim_set_current_line('- [ ] ')
  vim.api.nvim_win_set_cursor(0, { row, 6 })  -- after "- [ ] "
  return
end

-- Case 2: already has a bullet
local bullet, text = line:match '^([%s]*[-*]%s+)(.*)$'
if bullet then
  vim.api.nvim_set_current_line(bullet .. '[ ] ' .. text)
  vim.api.nvim_win_set_cursor(0, { row, #bullet + 4 })
  return
end

-- Case 3: plain text
vim.api.nvim_set_current_line('- [ ] ' .. line)
vim.api.nvim_win_set_cursor(0, { row, 6 })
```

The cursor positioning is deliberate: after inserting `[ ]`, the cursor lands after
the space following the bracket — ready for you to type or continue. The column is
0-indexed in the API, so `{ row, 6 }` for `"- [ ] "` lands after the trailing space.

The pattern `'^([%s]*[-*]%s+)(.*)'$` captures indentation + bullet character + spacing
as `bullet`, then the rest as `text`. This preserves indentation on nested bullets:

```
  - item        →    - [ ] item
^^^ preserved
```


---
[← Previous: Nix Tool Management](17-nix-tool-management.md) | [Home](README.md) | [Next: Terminal →](19-terminal.md)
