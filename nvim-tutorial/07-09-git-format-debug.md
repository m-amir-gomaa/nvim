# 07 — Git (gitsigns)

**File:** `lua/kickstart/plugins/gitsigns.lua`

---

## What gitsigns does

Gitsigns tracks the diff between your working tree and the git index (staged changes)
and displays this in the sign column (left gutter). Changes appear as coloured markers:
`+` added, `~` modified, `_` deleted. It also provides hunk-level operations that let
you stage, reset, or navigate changes without leaving Neovim.

---

## Navigation

```lua
map('n', ']c', ...)   -- Jump to next git change
map('n', '[c', ...)   -- Jump to previous git change
```

These jump between *hunks* — contiguous blocks of changes. The callback is smart:
if you're in a diff buffer (`:Gdiff` style), it uses Vim's native `]c` / `[c` which
navigate diff chunks. Otherwise it uses gitsigns' hunk navigation.

---

## Hunk operations

```lua
map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end)
map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end)
map('n', '<leader>hs', gitsigns.stage_hunk)
map('n', '<leader>hr', gitsigns.reset_hunk)
```

**Stage hunk** (`<leader>hs`) — Adds the current hunk to the git index (stages it),
without staging the whole file. Essential for crafting atomic commits from a messy
working tree.

**Reset hunk** (`<leader>hr`) — Reverts the current hunk to the HEAD version.
Undoes your local changes for just that block. In visual mode, you can select partial
lines to stage/reset.

```lua
map('n', '<leader>hS', gitsigns.stage_buffer)     -- stage entire file
map('n', '<leader>hR', gitsigns.reset_buffer)     -- revert entire file to HEAD
map('n', '<leader>hu', gitsigns.stage_hunk)       -- undo stage (unstage hunk)
```

---

## Inspection

```lua
map('n', '<leader>hp', gitsigns.preview_hunk)
```
**Preview hunk** — Shows a floating diff window of the current hunk. See exactly what
changed without opening a full diff.

```lua
map('n', '<leader>hb', gitsigns.blame_line)
```
**Blame line** — Shows a floating annotation for the current line: commit hash, author,
date, and commit message. Answers "who wrote this and why" without leaving the file.

```lua
map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
```
**Toggle inline blame** — Shows a ghost annotation at the end of every line with blame
info, always visible. Toggle off when it's distracting.

```lua
map('n', '<leader>hd', gitsigns.diffthis)
map('n', '<leader>hD', function() gitsigns.diffthis '@' end)
```
**Diff this** — Opens a side-by-side diff of the current file against the index.
With `'@'` as argument, diffs against the last commit (HEAD) instead.

---

## Practical workflow

The power is hunk-level staging. Instead of `git add file.go` (which stages everything),
you can:
1. Write several unrelated changes in one file
2. Navigate to the first logical change with `]c`/`[c`
3. Stage just that hunk with `<leader>hs`
4. Repeat for related hunks
5. Commit — only those staged hunks go into the commit

This lets you make "dirty" working sessions and still produce clean, atomic commits.

---

# 08 — Formatting & Linting

**Files:** `lua/custom/plugins/conform.lua`, `lua/kickstart/plugins/lint.lua`

---

## conform.nvim (formatting)

Conform handles code formatting. It's separate from the LSP — while LSPs can format,
a dedicated formatter often gives better results and is faster.

### Format on save

```lua
format_on_save = function(bufnr)
  local disable_filetypes = { c = true, cpp = true }
  if disable_filetypes[vim.bo[bufnr].filetype] then
    return nil
  else
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end
end,
```

Every save triggers formatting except for C/C++ (because clang-format can be
opinionated in unexpected ways). `lsp_format = 'fallback'` means: use the dedicated
formatter if available; if not, fall back to the LSP's formatting capability.

### Your formatters by language

| Language | Formatter | Notes |
|----------|-----------|-------|
| Lua | `stylua` | Opinionated, consistent. Config: `.stylua.toml` in your repo root |
| Go | `gofumpts` | Stricter superset of `gofmt` |
| JavaScript/TypeScript | `prettierd`, `prettier` | `prettierd` is a daemon — much faster |
| Markdown | `prettierd`, `prettier` | Note: prose-wrap settings matter here |
| HTML | `prettier` | |
| Nix | `nixpkgs-fmt`, `nixfmt` | |
| Python | `ruff` | Replaces `black` and `isort`. Extremely fast. |
| Bash / sh | `shfmt` | Standard shell script formatter. |
| YAML | `yamlfmt` | |

### Manual format

```lua
keys = {
  { '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end }
}
```

`<leader>f` — Format the current buffer manually. Useful when you've disabled
auto-format for a file, or want to format without saving.

---

## nvim-lint (linting)

Linting is different from formatting — formatters *fix* style, linters *report* issues.

### Your linters

| Language | Linter | Notes |
|----------|--------|-------|
| Markdown | `markdownlint-cli2` | Checks heading levels, link syntax, etc. |
| Lua | `selene` | Static analyser for Lua |
| Go | `golangci-lint` | Meta-linter running many Go linters |
| Bash/sh | `shellcheck` | Best-in-class shell script analyser |
| HTML | `htmlhint` | HTML structure and attributes |
| YAML | `yamllint` | Schema and structure validation |

### When linting fires

```lua
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  callback = function()
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
```

Linting runs: when you open a buffer, after you save, and when you leave insert mode.
The `vim.bo.modifiable` check prevents linting in read-only popup buffers (like hover
documentation).

### markdownlint config

Your `markdownlint.yaml` at the repo root configures which rules apply. The fixed path
`~/.config/nvim/markdownlint.yaml` means your Neovim config directory's YAML is used.
You can put project-specific rules in `.markdownlint.yaml` at project root — the linter
picks those up automatically.

---

# 09 — Debugging (nvim-dap)

**File:** `lua/kickstart/plugins/debug.lua`

---

## What DAP is

DAP (Debug Adapter Protocol) is to debuggers what LSP is to language servers — a
standard protocol between the editor and language-specific debug adapters. You set
breakpoints in Neovim, step through code, inspect variables, all without leaving the
editor.

---

## Your keymaps (F-key set)

| Key | Action |
|-----|--------|
| `<F5>` | Start debugging / Continue |
| `<F1>` | Step into function call |
| `<F2>` | Step over current line |
| `<F3>` | Step out of current function |
| `<F7>` | Toggle DAP UI panel |
| `<leader>b` | Toggle breakpoint at cursor |
| `<leader>B` | Set conditional breakpoint (prompts for condition) |

---

## Go debugging

```lua
require('dap-go').setup {
  delve = { detached = vim.fn.has 'win32' == 0 },
}
```

`nvim-dap-go` auto-configures `delve` (the Go debugger). When you open a Go file and
press `<F5>`, it asks how to run the program, starts delve, and attaches. Breakpoints
you've set light up.

**For tests:** Put cursor inside a test function and run `:DapGoTest` (or map it).
nvim-dap-go will start the test with the debugger attached.

---

## The DAP UI

```lua
dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
```

The UI opens automatically when a debug session starts and closes when it ends. It
shows: variables in scope, call stack, breakpoints list, a REPL for evaluating
expressions, and a console.

`<F7>` toggles it manually if you need to close/reopen mid-session.

---

## Adding Other Debuggers

Your configuration is "Nix-Native." Because `mason-nvim-dap` has been removed, you configure new debuggers by defining their **Adapter** and **Configuration** directly in `lua/kickstart/plugins/debug.lua`.

### The Nix Workflow for Debuggers:
1.  **Install the binary**: Add the debugger (e.g., `lldb`, `debugpy`, `js-debug-adapter`) to your `extraPackages` in `~/NixOSenv/nvim.nix`.
2.  **Define the Adapter**: Tell Neovim which executable to run.
3.  **Define the Configuration**: Tell Neovim *how* to run it for a specific filetype.

### Current Nix-Native Adapters:
- **Go**: Managed by `nvim-dap-go` using your system `delve`.
- **C / C++ / Rust**: Uses the system `lldb-dap` binary.
- **Python**: Uses the `debugpy` module from your system Python.

> **Pro Tip:** If a debugger isn't starting, check your Nix configuration first—the binary must be available in the environment for `nvim-dap` to find it.
