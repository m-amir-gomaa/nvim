# 03 — LSP (Language Server Protocol)

**Files:** `lua/custom/plugins/lspconfig.lua`, `lua/custom/plugins/lazydev.lua`

---

## What LSP is and why it matters

LSP is the reason modern Neovim can compete with IDEs. A language server is an external
process that understands a programming language — it parses your code, resolves types,
tracks references, and exposes this via a standard JSON-RPC protocol. Neovim speaks
that protocol.

The result: go-to-definition, hover documentation, inline errors, find-all-references,
rename across files, code actions — all language-agnostic, all driven by the same
infrastructure.

---

## The Nix-Native Toolchain (Pure NixOS Workflow)

```lua
-- LSP server binaries are now managed by Nix (via Home Manager) in `nvim.nix`.
-- This configuration simply sets up the connection to those existing binaries.
```

Your configuration uses a **Nix-Native** approach. Mason has been completely removed
from this setup because it is incompatible with the NixOS philosophy of deterministic,
reproducible environments. Adding LSPs, formatters, or debuggers is now done by:

1. Opening `/home/qwerty/NixOSenv/nvim.nix`
2. Adding the package name to `extraPackages`
3. Running your `nr` alias (nixos-rebuild switch)

This ensures your tools are pre-patched for the NixOS linker and never break after
a system update.

Your approach: declare language servers in your Nix config, let Nix put the binaries
on your PATH, then have nvim-lspconfig find them automatically. When you update your
system, LSP servers update atomically with everything else.

**The servers you have configured:**

| Server | Language | Notes |
|--------|----------|-------|
| `yamlls` | YAML | Schema validation, completions |
| `nil_ls` | Nix | The best Nix LSP currently |
| `gopls` | Go | Official Google Go LSP |
| `bashls` | Bash/sh | Uses `shellcheck` under the hood |
| `html` | HTML | Also handles embedded CSS/JS |
| `ts_ls` | TypeScript/JS | Formerly `tsserver` |
| `pyright` | Python | Type checking + completions |
| `marksman` | Markdown | Basic link checking & references |
| `markdown_oxide` | Markdown | Advanced Obsidian features (Backlinks, Rename) |
| `harper_ls` | Prose | Grammar and style checker |
| `lua_ls` | Lua | Configured for Neovim API awareness |

> **Rust Note:** `rust_analyzer` is managed exclusively by `rustaceanvim`. Do not
> add it to the `lspconfig` servers list or you'll get double-attach errors.

---

## The LspAttach autocmd — your keymaps

Every keymap below is **buffer-local**, set only when an LSP attaches to a buffer:

```lua
map('gd', tel.lsp_definitions, '[G]oto [D]efinition')
```
**`gd`** — Jump to where a symbol is defined. If there are multiple definitions
(e.g. interface + implementation), Telescope opens a picker.

```lua
map('gr', tel.lsp_references, '[G]oto [R]eferences')
```
**`gr`** — Find every location in your codebase that references this symbol. Results
go into a Telescope picker. Press `<C-q>` to send all to quickfix for bulk navigation.

```lua
map('gI', tel.lsp_implementations, '[G]oto [I]mplementation')
```
**`gI`** — For interfaces/abstract types, jump to a concrete implementation.

```lua
map('<leader>D', tel.lsp_type_definitions, 'Type [D]efinition')
```
**`<leader>D`** — Goes to the *type* definition rather than the value definition.
Useful in TypeScript/Go for jumping to `type Foo struct` from a usage.

```lua
map('<leader>ds', tel.lsp_document_symbols, '[D]ocument [S]ymbols')
```
**`<leader>ds`** — Opens a Telescope picker of all symbols in the current file:
functions, classes, variables. Fuzzy-searchable. Great for navigating large files.

```lua
map('<leader>ws', tel.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
```
**`<leader>ws`** — Same but searches across the *entire project*. Type a function name
to find it anywhere. This is a fast alternative to grep for navigating codebases.

```lua
map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
```
**`<leader>rn`** — Renames a symbol everywhere it's referenced across the project.
The rename is semantic — it understands scope, so renaming a local variable won't affect
a same-named variable in a different scope.

```lua
map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
```
**`<leader>ca`** — Opens a menu of actions the LSP can take at cursor position:
- Auto-import a missing package
- Extract selection to a function
- Implement an interface
- Fix a lint error automatically
- Add missing type annotations
- Remove unused imports

In visual mode `x`, code actions apply to the selection.

```lua
map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
```
**`gD`** — Unlike `gd` (definition), this goes to the *declaration* — in C-style
languages the difference matters (header vs implementation). In most languages they're
the same.

---

## Document highlight on hover

```lua
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  callback = vim.lsp.buf.document_highlight,
})
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  callback = vim.lsp.buf.clear_references,
})
```

When your cursor rests on a symbol (after `updatetime` milliseconds), Neovim highlights
every other occurrence of that symbol in the buffer. Move the cursor and they clear.
This is purely visual — it shows scope without any input from you.

---

## Inlay hints

```lua
map('<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
end, '[T]oggle Inlay [H]ints')
```

Inlay hints are ghost text injected inline by the LSP — they show inferred types,
parameter names, and return types without you hovering. Example in TypeScript:
```
const result = fetchUser(id)
//            ^ : Promise<User>     ← inlay hint
```

Toggle with `<leader>th`. Some people love them; others find them visual noise. Try
enabling them in a TypeScript or Go file to see if they help your workflow.

---

## fidget.nvim

```lua
{ 'j-hui/fidget.nvim', opts = {} }
```

Fidget shows LSP loading progress in the bottom-right corner. When you open a large
project and gopls or pyright are indexing, you see a spinner with the current task.
Without it, Neovim just looks frozen. Small but important for understanding your editor
state.

---

## Neovim 0.11+ vs older LSP setup

```lua
if vim.fn.has 'nvim-0.11' == 1 then
  vim.lsp.config(server_name, server_config)
  vim.lsp.enable(server_name)
else
  require('lspconfig')[server_name].setup(server_config)
end
```

Neovim 0.11 introduced a native `vim.lsp.config`/`vim.lsp.enable` API that doesn't
require nvim-lspconfig as a bridge. Your config uses it when available, falls back to
lspconfig. This future-proofs you — eventually lspconfig will be optional entirely.

---

## lazydev.nvim

**File:** `lua/custom/plugins/lazydev.lua`

```lua
'folke/lazydev.nvim',
ft = 'lua',
opts = {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
},
```

When you're editing Lua files — including your own Neovim config — `lazydev` configures
`lua_ls` to know about the Neovim API. This means:
- `vim.keymap.set` gets proper type completions
- `vim.api.nvim_*` functions autocomplete with correct signatures
- `require('some.plugin')` resolves correctly for installed plugins
- You get hover documentation for Neovim's built-in functions

Without this, `lua_ls` complains that `vim` is undefined.

The `luv` library entry adds `vim.uv` support (the libuv async bindings).

---

## Practical exercises

1. **Test `gd` vs `gD`:** In a Go file, put cursor on a function call and press `gd`
   (goes to definition). In a C file, try `gD` to see the difference.

2. **Try workspace symbols:** Press `<leader>ws` and type a partial function name.
   Watch it search across your entire project live.

3. **Use a code action:** Put cursor on an unused import in TypeScript/Python and press
   `<leader>ca` — look for "Remove unused import" or similar.

4. **Toggle inlay hints:** In a Go or TypeScript file, press `<leader>th` and compare
   the buffer before and after.

5. **Trigger document highlight:** Open a file, hold your cursor still on a variable
   name for ~250ms. All other occurrences should highlight.
