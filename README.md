# Neovim Configuration

A personalized Neovim configuration.

## Key Features
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP Support**: Configured via `nvim-lspconfig` and Nix/Home Manager.
- **Autocomplete**: [blink.cmp](https://github.com/Saghen/blink.cmp)
- **Fuzzy Finding**: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- **Treesitter**: For advanced syntax highlighting.
- **Debugging**: [nvim-dap](https://github.com/mfussenegger/nvim-dap) with Go support.
- **Markdown & UML**: 
  - **UML**: Dedicated PlantUML viewer using `weirongxu/plantuml-previewer.vim`.
  - **Images**: Professional image pasting from clipboard via `img-clip.nvim`.
  - **Math**: LaTeX/Math support via `snacks.nvim`.
- **Navigation**:
  - **Cursor Persistence**: Reopens files exactly where you left them.
  - **Folding**: Authentic Linkarzu-style folding for Markdown (clean visual headers, `<CR>` to toggle).

## Structure
- `init.lua`: Main entry point and core settings.
- `lua/custom/plugins/`: Modular plugin configurations.
- `lua/custom/keybindings/`: Custom mappings and keyboard logic.
- `nvim.nix`: System-level toolchain (LSPs, formatters) managed by NixOS.

## Development Workflow
This configuration is tightly integrated with **NixOS**.
- **Tool Management**: Add LSPs/binaries to `nvim.nix`.
- **Sync**: `nvim.nix` is hard-linked between `~/nvim` and `~/NixOSenv` for seamless editing and immediate availability in both repositories.
- **Rebuild**: Apply changes with the `nr` command.

## Keybindings (New)
- `<leader>dv`: [D]iagram [V]iew (Open browser preview for PlantUML)
- `<leader>ds`: [D]iagram [S]ave (Save diagram as image)
- `<leader>ip`: [I]mage [P]aste (Paste and save image from clipboard)
- `<C-j>`/`<C-k>`: Completion navigation (prevents `tmux`/`telescope` conflicts)
- `<CR>`: Toggle fold (in Markdown/Typst)

## Prerequisites
- Neovim (latest stable or nightly)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- A [Nerd Font](https://www.nerdfonts.com/) (optional, but recommended)
