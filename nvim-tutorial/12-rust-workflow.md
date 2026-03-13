# 12 — Rust Workflow (The Full Toolstack)

**Files:** `lua/custom/plugins/rustaceanvim.lua`, `after/ftplugin/rust.lua`,
`lua/kickstart/plugins/debug.lua`, `~/NixOSenv/nvim.nix`

---

## Your Rust Toolchain Breakdown
On NixOS, your Rust setup is split between your **System** and your **Neovim Shell**. Here is exactly what is doing what:

### 1. The Core (System Level)
These are installed globally in `configuration.nix` and are always available in your terminal.
- **`cargo`**: The heart of Rust. It handles packages (crates), builds your code (`cargo build`), and manages your projects.
- **`rustc`**: The actual compiler. You rarely call it directly; Cargo does it for you.
- **`clippy`**: The "linter." It tells you how to write better, more "Idiomatic" Rust. It runs inside Neovim via the LSP.
- **`rustfmt`**: The formatter. It ensures your code follows the standard Rust style. Triggered by `:Format` or on save.
- **`gcc` / `make` / `cmake`**: Behind-the-scenes build tools. Rust needs these to link your code into an executable.

### 2. The Language Server (Neovim Level)
These are provided by `nvim.nix` and are only "visible" to Neovim.
- **`rust-analyzer`**: The "brain" inside your editor. It provides the completions, types, and error highlighting.
- **`rustaceanvim`**: The plugin that manages `rust-analyzer`. It provides the `RustLsp` command and enhanced UI.

### 3. The Debugger
- **`lldb`**: The system debugger.
- **`lldb-dap`**: The bridge that lets Neovim talk to the debugger. Configured in `debug.lua`.

### 4. Integration Note
**`rustaceanvim`** is special: it bypasses the standard `lspconfig.lua` entirely. This is intentional. Because Rust has unique needs (like `Cargo.toml` management and complex inlay hints), this plugin provides a deeper, more stable integration than the generic LSP layer.

---

## Key Plugin: rustaceanvim
Standard nvim-lspconfig can run `rust_analyzer`, but rustaceanvim gives you "IDE-level" features:

- **Hover actions (`K`)** — Instead of just text, you get an interactive menu with:
  - Run/Debug current function
  - Open documentation on `docs.rs`
  - Expand macros inline
- **Runnables** — `:RustLsp runnables` scans your project for anything that can be run (main, tests, examples) and lists them in a picker.
- **Testables** — `<Leader>dt` specifically finds and runs tests.

---

## Keymaps (Rust-only)

```lua
map('n', '<leader>cr', function() vim.cmd.RustLsp 'codeAction' end, { desc = 'Rust code action' })
```
- **Fill missing fields**: Put cursor on a struct and it will generate the boilerplate code for you.
- **Convert if-let to match**: Instantly refactor logical blocks.

```lua
map('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, { desc = 'Rust hover actions' })
```
- Your primary way to interact with the code. If you're unsure what a type is, or want to run a test, press `K`.

---

## Helpful Commands
| Command | Result |
|---------|--------|
| `:RustLsp expandMacro` | Shows what a macro (like `println!`) actually produces. |
| `:RustLsp explainError` | Gives a detailed explanation of why the compiler is complaining. |
| `:RustLsp openCargo` | Instantly jump to your `Cargo.toml`. |
| `:RustLsp moveItem up/down` | Move functions or struct fields up/down with one key. |

---

## The "Bacon" Workflow (Optional but Recommended)
If you find yourself constantly running `cargo check`, consider adding `bacon` to your `nvim.nix`. It's a background watcher that shows errors in a separate terminal split, extremely fast and light.

---

## Practical Exercises
1. **The "Action Hover"**: Open a Rust file, put your cursor on a `#[test]` and press `K`. Select "Run" from the menu.
2. **Boilerplate generation**: Create a struct, then try to instantiate it without fields. Use `<leader>cr` and select "Fill struct fields."
3. **Macro deep-dive**: Put your cursor on `vec![1, 2, 3]` and run `:RustLsp expandMacro`.
