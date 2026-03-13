# 17 — Nix-Native Tool Management

**Files:** `~/NixOSenv/nvim.nix`, `~/NixOSenv/home.nix`, `lua/custom/plugins/lspconfig.lua`

---

## The Philosophy: Infrastructure as Code
On NixOS, your editor's tools (LSPs, Formatters, Debuggers) are not "installed" via an editor plugin. They are defined as **Infrastructure**. This means your editor environment is 100% reproducible and will never break because of a missing binary or a weird dynamic linker error.

## 1. Where the tools live
The "Brain" of your toolchain is in **`nvim.nix`**. 

> [!NOTE]
> For maximum convenience, `nvim.nix` is **hard-linked** between `~/NixOSenv/` and `~/nvimConfig/`. Changes made in your Neovim workspace are instantly reflected in your system configuration.

Inside `extraPackages`, you list every binary Neovim needs.
```nix
extraPackages = with pkgs; [
  # ── Language Servers (LSPs) ──────────────────────────────────────────
  gopls                                    # Go
  nodePackages.vscode-langservers-extracted # HTML, CSS, JSON, ESLint
  nodePackages.typescript-language-server  # TypeScript / JavaScript
  yaml-language-server                     # YAML
  nil                                      # Nix
  bash-language-server                     # Bash / Shell
  pyright                                  # Python
  clang-tools                              # C/C++ (clangd)
  lua-language-server                      # Lua
  marksman                                 # Markdown links
  rust-analyzer                            # Rust
  taplo                                    # TOML
  markdown-oxide                           # Obsidian-style backlinks

  # ── Formatters ──────────────────────────────────────────────────────
  stylua gofumpt shfmt black isort ruff
  nodePackages.prettier nodePackages.eslint_d prettierd
  nixfmt alejandra

  # ── Linters ──────────────────────────────────────────────────────────
  shellcheck selene golangci-lint
  yamllint htmlhint markdownlint-cli2 cppcheck

  # ── Debug adapters ───────────────────────────────────────────────────
  delve lldb python313Packages.debugpy

  # ── Snacks.nvim integrations ─────────────────────────────────────────
  lazygit ghostscript tectonic mermaid-cli
  plantuml graphviz jdk   # UML diagrams
  trash-cli

  # ── Build tools for Treesitter parsers ───────────────────────────────
  gcc gnumake git tree-sitter
];
```

### Why this is better than Mason:
- **Zero Startup Lag**: Neovim doesn't need to check "Is this tool installed?" on every launch. It's already on the PATH.
- **Immutable & Safe**: If you accidentally delete a binary, a simple `nr` restore it.
- **One Command to Rule All**: Update your whole OS, and your editor tools update with it.

---

## 2. The Management Workflow
When you want to add a new language (e.g., Haskell or Zig), you don't use `:Mason`. You do this:

1. **Find the package**: Search on [search.nixos.org](https://search.nixos.org) for the LSP or tool.
2. **Add to `nvim.nix`**: Add it to the `extraPackages` list.
3. **Rebuild**: Run your **`nr`** alias.
   ```bash
   nr
   ```
4. **Connect in Neovim**: Open `lua/custom/plugins/lspconfig.lua` and add the server to the `servers` table.

---

## 3. Hermetic Isolation
One of the coolest parts of your setup is that these tools are **isolated**.
If you run `which gopls` in your normal terminal, it might say "not found." But if you run `:!which gopls` inside Neovim, it will show the path in the `/nix/store/`.

This prevents your system from being cluttered with hundreds of development binaries that you only need when coding.

## 4. Advanced Management

### The hybrid model (Nix + Lazy)
Your setup uses a "Hybrid" approach:
- **Nix** manages the system binaries (engine).
- **lazy.nvim** manages the Neovim plugins (UI/UX).

Your `lazy-lock.json` pins plugins to specific commits for reproducibility. While you *could* manage plugins via Nix, this hybrid approach is faster for testing new plugins without a full system rebuild.

### Pinned Treesitter
On NixOS, unexpected Treesitter updates can sometimes break highlighting. You can pin Treesitter in your `lazy-lock.json` or by adding a tag in your plugin config:
```lua
'nvim-treesitter/nvim-treesitter',
tag = 'v0.9.3', -- Uncomment if you need strict stability
```

### Environment Variables
For tools that need secrets (like Imgur or GitHub tokens), don't hardcode them in your Lua files. Add them to your Nix session variables:
```nix
home.sessionVariables = {
  IMGUR_CLIENT_ID = "your_id_here";
};
```
Then access them in Neovim with `os.getenv('IMGUR_CLIENT_ID')`.

## 5. Checking Health
After any change to `nvim.nix`, run:
```vim
:checkhealth
```
This is the single most important command for debugging your toolchain. It will verify that your Nix store paths are correctly linked to your Neovim session.

---

## Practical Exercises
1. **The Discovery**: Open `~/NixOSenv/nvim.nix` and find where `pyright` is listed. 
2. **The PATH Test**: Inside Neovim, run `:!which rust-analyzer`. Observe the long `/nix/store/...` path.
3. **The Health Check**: Run `:checkhealth lspconfig` and see how it cleanly finds your system-provided binaries.
