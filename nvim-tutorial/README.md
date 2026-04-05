# Your Neovim Config — Complete Tutorial

Written specifically for **your** configuration. Every section maps to real files
in your setup. Not a generic Neovim guide — a walkthrough of the exact system you've
built, including the parts that feel unexplored.

---

## Files in this tutorial

| File | Contents |
|------|----------|
| [00-cheatsheet.md](00-cheatsheet.md) | Every keymap, one page |
| [01-core-options.md](01-core-options.md) | `init.lua` options, diagnostics config, lazy bootstrap |
| [02-keymaps-core.md](02-keymaps-core.md) | Hand-written keymaps and the reasoning behind them |
| [03-lsp.md](03-lsp.md) | LSP setup, NixOS approach, every attached keymap |
| [04-completion.md](04-completion.md) | blink.cmp, LuaSnip, snippets, sources |
| [05-treesitter.md](05-treesitter.md) | Syntax, textobjects, context window, textobject motions |
| [06-telescope.md](06-telescope.md) | Every picker, multi-ripgrep, quickfix power moves (`:cdo`/`:cfdo`) |
| [07-09-git-format-debug.md](07-09-git-format-debug.md) | gitsigns, conform, nvim-lint, nvim-dap |
| [10-file-navigation.md](10-file-navigation.md) | Harpoon 2, neo-tree, oil.nvim, marks, undotree |
| [11-markdown-workflow.md](11-markdown-workflow.md) | The full markdown system — rendering, folding, tasks, images |
| [12-rust-workflow.md](12-rust-workflow.md) | rustaceanvim, hover actions, testables |
| [13-ui-appearance.md](13-ui-appearance.md) | Colorscheme, snacks modules, mini.nvim, which-key, indent |
| [14-editing-tools.md](14-editing-tools.md) | visual-multi, autopairs, outline, sleuth |
| [15-16-search-diagnostics.md](15-16-search-diagnostics.md) | grug-far, trouble, built-in diagnostic navigation |
| [17-nix-tool-management.md](17-nix-tool-management.md) | Managing LSPs, formatters, and debuggers via `nvim.nix` & rebuilds |
| [18-implementation-deep-dives.md](18-implementation-deep-dives.md) | How your complex Lua actually works, line by line |
| [19-terminal.md](19-terminal.md) | Floating terminal — toggle, terminal mode, configuration |
| [20-advanced-workflow.md](20-advanced-workflow.md) | How to put it all together into a fast development loop |
| [21-nix-on-any-os.md](21-nix-on-any-os.md) | Using Nix to manage tools on macOS, WSL, and other Linux distros |
| [22-ai-features.md](22-ai-features.md) | Mark (Sovereign Assistant) |
| [24-mark-setup.md](24-mark-setup.md) | Mark Keys Setup |
| [25-opencode-specialist.md](25-opencode-specialist.md) | OpenCode (Coding Specialist) |
| [26-opencode-setup.md](26-opencode-setup.md) | OpenCode Keys Setup |
| [23-mark-architecture.md](23-mark-architecture.md) | Mark Architecture & Mermaid Diagrams |

---

## Start here depending on what you want

**"I want to find features I'm probably not using"**
→ Start with `00-cheatsheet.md`, scan for unfamiliar keys, then jump to the relevant file.

**"I want to understand the markdown workflow fully"**
→ `11-markdown-workflow.md` then `18-implementation-deep-dives.md`

**"I want to get more out of LSP and code navigation"**
→ `03-lsp.md`, `05-treesitter.md`, `06-telescope.md` in that order

**"I want to understand what's new after the config fixes"**
→ New plugins: `trouble.nvim` (§15-16), `grug-far` (§15-16),
  `treesitter-context` + `textobjects` (§05), `friendly-snippets` (§04), expanded
  `snacks.nvim` modules like **Image (Kitty Protocol)**, **Mermaid/UML**, and **LaTeX Math Rendering** (§11/13),
  and **AI integrated via Mark** (§22).

**"I want to understand the Lua behind a keymap"**
→ `18-implementation-deep-dives.md`

---

## One real thing to try right now

Open any code file and press `]f` to jump to the next function, or `]h` to jump to the next git hunk.
