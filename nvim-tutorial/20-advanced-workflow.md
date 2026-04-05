# Advanced TJ DeVries Integrations

As an advanced user (1.5+ years of Neovim experience), this configuration includes powerful workflow integrations inspired by TJ DeVries.

## 1. Quickfix & Telescope (`<C-q>` and `:cdo`)
When using `live_grep` or `multi_grep` (`<leader>sM`), you can send all results directly to Neovim's Quickfix list by pressing `<C-q>`.
This enables massive project-wide refactoring. Once the quickfix list is open, you can run commands across every matched file:
```vim
:cdo s/old_name/new_name/gc
:cfdo update
```

## 2. Lua Scratchpads (`luai.nvim`)
Instead of `print()` debugging Lua code, you can use `luai.nvim` to execute code segments instantly.
- `<leader>xl`: Execute the entire current file.
- `<leader>xx`: Execute the highlighted/current line.

## 3. Custom Statusline (`express_line.nvim`)
The configuration utilizes `express_line.nvim`, a pure Lua, co-routine based statusline. This is significantly more customizable and performant than `lualine`, allowing for complex asynchronous git branch and diagnostic fetching without blocking the main thread.

## 4. Git Conflict Resolution (`diff-therapy.nvim`)
A highly specialized workflow for resolving git merge conflicts.
- `<leader>dt`: Open the diff therapy UI to quickly select remote/local changes.

## 5. Live Presentations (`present.nvim`)
You can turn any markdown file into an interactive slideshow within Neovim.
- `<leader>mp`: Start the markdown presentation.

## 6. Advanced Text Objects
Tree-sitter is configured with advanced scope-level highlighting and text objects. On top of standard `af` (around function), you can use:
- `as` / `is`: Select language scope (the precise syntax tree block).
- `ar` / `ir`: Target function return statements instantly.


---
[← Previous: Terminal](19-terminal.md) | [Home](README.md) | [Next: Nix on Any OS →](21-nix-on-any-os.md)
