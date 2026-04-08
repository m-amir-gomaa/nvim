# 21 — Nix on Any OS (Non-NixOS Guide)

**Targets:** macOS, Ubuntu, Fedora, WSL — anywhere the Nix Package Manager is installed.

---

## 1. Why Nix on a "Normal" OS?
If you use Neovim on macOS or a standard Linux distro, you usually rely on `brew` or `apt`. Nix is better for your Neovim setup because:
- **Project Isolation**: Every machine you use (work, home, laptop) will have the *exact* same version of `gopls` or `rust-analyzer`.
- **No Global Mess**: You don't need to install 50 development binaries globally. You can keep them isolated.

---

## 2. Option A: Manual Management (`nix profile`)
The simplest way to use Nix if you don't want to manage your whole home directory.

**To install your tools:**
```bash
# Add the tools you need
nix profile install nixpkgs#gopls nixpkgs#rust-analyzer nixpkgs#stylua nixpkgs#ripgrep
```

**To update:**
```bash
nix profile upgrade '.*'
```

---

## 3. Option B: Standalone Home Manager (Recommended)
This is the closest experience to your current NixOS setup. You create a `~/.config/home-manager/home.nix` file (even on macOS!) and list your packages there.

**Setup summary:**
1. Install Nix.
2. Install [Home Manager](https://github.com/nix-community/home-manager).
3. Copy your `nvim.nix` logic into your standalone `home.nix`.
4. Run `home-manager switch`.

---

## 4. The Tool List (Language by Language)
When installing via Nix on any OS, use these package names to ensure compatibility with your Kickstart config:

| Language | LSP Server | Formatter | Linter / Other |
|----------|------------|-----------|----------------|
| **Go** | `nixpkgs#gopls` | `nixpkgs#gofumpt` | `nixpkgs#golangci-lint`, `nixpkgs#delve` |
| **Rust** | `nixpkgs#rust-analyzer` | `rustc/cargo` | `nixpkgs#lldb` |
| **Python** | `nixpkgs#pyright` | `nixpkgs#ruff` | `nixpkgs#python313Packages.debugpy` |
| **Web** | `nixpkgs#nodePackages.typescript-language-server` | `nixpkgs#prettierd` | `nixpkgs#nodePackages.eslint_d` |
| **Lua** | `nixpkgs#lua-language-server` | `nixpkgs#stylua` | `nixpkgs#selene` |
| **Nix** | `nixpkgs#nil` | `nixpkgs#nixfmt-rfc-style` | |

---

## 5. Connecting to Neovim
Once tools are installed via Nix, Neovim needs to find them. On non-NixOS systems, Nix usually puts binaries in `~/.nix-profile/bin/`.

Ensure this is in your shell's `.bashrc` or `.zshrc`:
```bash
export PATH="$HOME/.nix-profile/bin:$PATH"
```

Once that's set, your `lspconfig.lua` will work exactly as it does on NixOS—it will just find `gopls` or `pyright` on your PATH.

---

## 6. Pro Tip: `direnv` + `shell.nix`
Instead of installing tools globally, you can have them appear **only when you enter a project folder**.
1. Create a `shell.nix` in your project root.
2. Run `direnv allow`.
3. When you `cd` into the project, the LSP/Tools appear. When you `cd` out, they vanish.
   *This is the ultimate professional workflow for keeping a clean system.*

---

## Practical Exercises
1. **The Standalone Install**: If you have a second computer (even a Mac), install Nix and try:
   `nix profile install nixpkgs#ripgrep`
   Then check if `:Telescope live_grep` works in Neovim.
2. **The PATH Check**: Verify your Nix profile is leading your PATH:
   `echo $PATH | grep .nix-profile`


---
[← Previous: Advanced Workflow](20-advanced-workflow.md) | [Home](README.md)
