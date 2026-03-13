# 11 — The Markdown Workflow

**Files:** `lua/custom/plugins/render-markdown.lua`, `lua/custom/plugins/img-clip.lua`,
`lua/custom/plugins/snacks.lua` (image), `lua/custom/keybindings/linkarzu_keybindings/`

This is the most evolved and personal part of your config — a full markdown editing
environment built over years. It's worth understanding every piece.

---

## render-markdown.nvim

This plugin transforms markdown in normal mode — it renders headings, tables, checkboxes,
code blocks, links, and callouts visually, hiding the raw syntax. When you move your
cursor to a line, the raw markdown reveals itself (anti-conceal). Move away and it
re-renders.

### What renders

**Headings** — Full-width coloured background bars with custom icons:
```
󰲡 Your Heading Here
```
The icons `󰲡 󰲣 󰲥 󰲧 󰲩 󰲫` correspond to H1–H6.

**Code blocks** — Language tag shown on left, dark background, fence delimiters hidden:
```
lua  ← shown in colour
local x = 1
```

**Checkboxes** — `[ ]` renders as `󰄱 `, `[x]` as `󰱒 `, `[-]` as `󰥔 ` (your
custom "in progress" state).

**Tables** — Box-drawing characters replace the `|` delimiters. Cells are padded to
equal widths. The result looks like a proper table, not ASCII art.

**Links** — Custom icons per domain: `󰊤 ` for GitHub, `󰗃 ` for YouTube, `󰖟 ` for
generic web, `󰀓 ` for email.

**Callouts** — GitHub-style `[!NOTE]`, `[!WARNING]` etc. render with icons and coloured
backgrounds. You have the full Obsidian callout set too: `[!TIP]`, `[!BUG]`,
`[!SUCCESS]`, etc.

**Inline highlights** — Text surrounded by `==like this==` gets an inline highlight
background (Obsidian-style).

### Anti-conceal

```lua
anti_conceal = { enabled = true, above = 0, below = 0 }
```

When your cursor is on a heading, the raw `## ` reappears. On a link, you see
`[text](url)`. Move off it and it re-renders. This means you always have clean visual
output but can edit the raw markdown anywhere.

### render_modes

```lua
render_modes = { 'n', 'c', 't' }
```

Rendering is active in normal, command, and terminal modes. In insert mode, everything
shows raw markdown — so you can see exactly what you're typing.

---

## Folding (`folding_section.lua`)

Your folding system is custom-built using treesitter-aware fold expressions. For markdown,
headings define fold boundaries.

### Fold keymaps (markdown/typst only)

| Key | Action |
|-----|--------|
| `zj` | Fold all H1 and below (everything) |
| `zk` | Fold all H2 and below |
| `zl` | Fold all H3 and below |
| `z;` | Fold all H4 and below |
| `zu` | Unfold everything |
| `zi` | Jump to heading above and fold it |
| `<CR>` | Toggle fold at cursor (any filetype) |

These are **buffer-local** — they only apply in markdown/typst files and don't override
Vim's built-in fold motions elsewhere.

The fold engine uses a custom `markdown_foldexpr()` that handles YAML frontmatter
correctly — the frontmatter `---` markers don't trigger heading-level folds.

---

## Task management (`markdown.lua`)

### Task states

You have a three-state task system:
- `- [ ]` — pending
- `- [x]` done: YYMMDD-HHMM\`` — completed (with timestamp)
- `- [ ]` \``untoggled\`` — explicitly marked as not-done (de-completed)

### `<M-x>` — the smart task toggle

The most complex keymap in your config. On a `- [ ]` task:
1. Marks it as `- [x]` with a timestamp label
2. Moves the entire task (including multi-line sub-content) to the `## Completed Tasks`
   section at the bottom of the file
3. If the section doesn't exist, creates it

On a task in the completed section:
1. Pressing again marks it `untoggled`
2. Pressing a third time cycles back to done

### `<M-l>` — create task bullet

Converts the current line into a task or inserts a new `- [ ]` task:
- Empty line → `- [ ] ` (positions cursor after the brackets)
- Line with `- item` → `- [ ] item` (adds checkbox to existing bullet)
- Plain text line → `- [ ] text` (wraps in task format)

`<leader>x` (simple toggle)

A lighter version: toggles `[ ]` ↔ `[x]` in place without moving the task anywhere.
Use when you want to check things off without reorganising the file. Found in
`mappings.lua`.

---

## Image handling

### img-clip.nvim

**`<leader>ip`** (in `image_pasting.lua`) — Pastes an image from your clipboard into the current markdown file:
1. Saves the image as a file into the `assets/` directory.
2. Inserts a markdown `![image](assets/path)` reference.
3. Automatically prompts for a filename to keep your project organized.

**`<M-1>`** (in `extra_keybindings_linkarzu.lua`) — More advanced paste for blog posts:
- Saves to your `assets/img/imgs/` directory
- Prompts whether it's a thumbnail image
- Lets you choose format (avif, webp, png, jpg)
- Lets you set resolution with imagemagick
- Inserts attribution text and captions

**`<leader>si`** — Pick an existing image from the project using Snacks picker and
insert it at cursor position.

### Snacks image rendering & Kitty Protocol

```lua
image = {
  enabled = true,
  backend = 'kitty', -- Explicitly set to use Kitty graphics protocol
  doc = { inline = true, float = true, only_render_image_at_cursor = true }
}
```

Images and diagrams referenced in markdown render as actual previews in your terminal. This setup is specifically optimized for the **Kitty terminal** (0.45.0+) using its native graphics protocol.

- **Inline Rendering**: Diagrams and images appear directly within the markdown buffer when `inline = true`.
- **At-Cursor Only**: `only_render_image_at_cursor = true` ensures that only the image your cursor is on renders, preventing visual clutter and ensuring performance.

---

## Diagrams & UML (PlantUML & Mermaid)

Your setup supports both **PlantUML** and **Mermaid.js** diagrams.

### 1. PlantUML (Dedicated Viewer)
For professional UML work, you have a dedicated browser-based previewer.
- **Keybinding**: **`<leader>dv`** (Diagram View) while in a `.puml` file.
- **How it works**: Uses `weirongxu/plantuml-previewer.vim` to compile your diagram using `plantuml` (Java) and open it in your browser.
- **Sync**: The preview updates automatically whenever you save the file.

### 2. Mermaid.js (Inline)
Smaller diagrams can be rendered directly in your terminal using the Kitty graphics protocol.
- **How it works**: Snacks.nvim detects `mermaid` code blocks and uses `mmdc` to render them inline.
- **Treesitter**: Requires the `mermaid` parser (`:TSUpdate mermaid`).

---

## Math & LaTeX Rendering

LaTeX math expressions are rendered beautifully in-line.

### Inline & Block Math
- **Inline**: `$E = mc^2$`
- **Block**:
  ```latex
  \begin{equation}
  \int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
  \end{equation}
  ```

### Rendering Engine
Snacks.nvim uses **Tectonic** (a modern LaTeX engine) or **MathJax** to convert LaTeX strings into high-quality images for terminal display.
- **Enabled via**: `math = { enabled = true }` in snacks config.
- **Verification**: Run `:checkhealth snacks` to ensure `tectonic` or `mathjax` is detected.

---

### Imgur upload (`<M-i>`)

`<M-i>` uploads the image from your clipboard to your authenticated Imgur account:
1. Reads tokens from your credentials file
2. Posts the image via Imgur API
3. Inserts the Imgur URL as markdown
4. Auto-refreshes expired access tokens

Credentials live at `~/Library/Mobile Documents/...` on macOS or a custom path on Linux.
Your script currently points to the iCloud path — if you're on Linux, updated the
`env_file_path` in `imgur.lua`.

---

## Image management keymaps

| Keymap | Action |
|--------|--------|
| `<leader>iR` | Rename image under cursor (updates all references in file) |
| `<leader>id` | Delete image file under cursor (uses `trash` or `rm`) |
| `<leader>if` | Open image in File Manager (ForkLift/Nautilus/etc) |

---

## Other markdown utilities

### `<leader>ml` — Copy all HTTPS links

Scans the entire buffer, extracts every unique HTTPS URL (with smart trailing-character
trimming for parentheses and punctuation), and copies them all to clipboard, one per
line.

### `<leader>mR` — Restart Marksman LSP

Checks if Marksman is running and either starts it or restarts it. Useful when it
gets stuck or when you want to force re-indexing.

### `vio` — Select inside code block

Visually selects all text between the opening ` ```lang ` fence and the closing ` ``` `.
Useful for copying out a code block's content, reformatting it, or replacing it.

### TOC generation (`<leader>mtt` / `<leader>mts`)

Uses `markdown-toc` CLI to generate/update a table of contents. Inserts `<!-- toc -->`
comment marker and a TOC under the first H1. `<leader>mtt` for English headings,
`<leader>mts` for Spanish.

### Bold/italic/strikethrough

```
<leader>mb   (visual)   -- bold selection
<leader>mb   (normal)   -- toggle bold on word under cursor
<leader>mx   (visual)   -- strikethrough selection
gss          (visual)   -- surround with backticks (inline code)
gss          (normal)   -- surround current word with backticks
gsu                     -- surround URL under cursor with backticks
```

### Heading increase/decrease

`<leader>mh` group (defined in which-key) — check markdown.lua for specific bindings
that increase/decrease heading levels.

### Spell checking

| Keymap | Action |
|--------|--------|
| `<leader>msle` | Set spell language to English |
| `<leader>msls` | Set spell language to Spanish |
| `<leader>mslb` | Set spell language to both |
| `<leader>mss` | Accept first spelling suggestion |
| `<leader>msg` | Mark word as good (add to spellfile) |
| `<leader>msu` | Undo "good word" |
| `<leader>msr` | Repeat last correction across file |

### Format all markdown in repo

`<leader>mfA` — Runs conform/prettier on every `.md` file in the git repository.
Useful for batch-normalising a documentation site.

### YouTube embed management

`<leader>mfy` / `<leader>mfY` — Moves YouTube `{% include embed/youtube.html %}` tags
in your Jekyll/blog markdown files to a dedicated `## Other videos mentioned` section.
Highly specific to your blogging workflow.

---

---

## 🚀 Advanced Zettelkasten & Obsidian Features

Your setup is a high-performance "Second Brain" environment:

### 1. Obsidian.nvim Integration
Deep linkage with your vault at `~/Notes`:
- **Smart Following** (`gf`): Wiki-links `[[Note Name]]` and standard links are followed using vault-aware search.
- **ID Generation**: `:ObsidianNew` generates Zettelkasten-compliant IDs (timestamp + slug).
- **Daily Notes**: Access your journal instantly using `:ObsidianToday`. Templates are pulled from `06-Templates`.
- **UI Elements**: Checkboxes, bullets, and external links are enhanced with custom icons and highlights.

### 2. The Markdown Oxide Engine (LSP)
Provides IDE-grade features for your notes:
- **Vault-wide Backlinks**: `gr` on any note title or link to see all references.
- **Global Rename**: `<leader>rn` renames a note and updates all links across your entire vault.
- **Unresolved Links**: Instantly spot links that haven't been created yet.

### 3. Git Auto-Sync (`markdown-sync.lua`)
Zero-effort backup:
- Every save (`:w`) triggers a background Git sync.
- Automates `git add .`, `git commit -m "Auto-save: ..."` and `git push`.
- Works silently in the background via `jobstart` to ensure your editor never freezes.

---

## Practical exercises

1. **Render modes:** Open a markdown file in normal mode. Note the rendering. Enter
   insert mode (`i`) — observe the raw markdown. Leave insert mode. Rendering returns.

2. **Fold all headings:** In a markdown file with multiple headers, press `zk` to fold
   everything H2 and deeper. `zu` to unfold.

3. **Task workflow:** Create a few `- [ ]` tasks with `<M-l>`. Complete one with
   `<M-x>`. Observe it move to the completed section with a timestamp.

4. **Select code block:** Put cursor inside a fenced code block and press `vio` to
   select its contents.

5. **Copy all links:** In a markdown file with several links, press `<leader>ml` and
   paste into another buffer — all URLs extracted.
