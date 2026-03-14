# Quick Reference — All Your Keymaps

A single-page cheatsheet of every keymap in your config, grouped by context.

---

## Core (always available)

| Key          | Action                           |
| ------------ | -------------------------------- |
| `<Space>`    | Leader key                       |
| `jk`         | Exit insert mode                 |
| `Y`          | Yank to end of line              |
| `J` (normal) | Join lines (cursor stays)        |
| `n` / `N`    | Next/prev search match (centred) |
| `<Esc>`      | Clear search highlight           |
| `<CR>`       | Toggle Linkarzu-fold (Markdown)  |

## Windows & Tabs

| Key           | Action                  |
| ------------- | ----------------------- |
| `<C-h/j/k/l>` | Move between splits     |
| `gtn` / `gtp` | Next / previous tab     |
| `<leader>tn`  | New tab                 |
| `bn` / `bp`   | Next / previous buffer  |
| `b^`          | Alternate (last) buffer |
| `bk`          | Delete current buffer   |

## Telescope

| Key                | Action                     |
| ------------------ | -------------------------- |
| `<leader>sf`       | Find files                 |
| `<leader>sg`       | Live grep                  |
| `<leader>sM`       | Multi-grep (pattern glob)  |
| `<leader>sw`       | Grep word under cursor     |
| `<leader>sh`       | Search help                |
| `<leader>sk`       | Search keymaps             |
| `<leader>ss`       | All pickers                |
| `<leader>sd`       | Diagnostics                |
| `<leader>sr`       | Resume last picker         |
| `<leader>s.`       | Recent files               |
| `<leader><leader>` | Open buffers               |
| `<leader>/`        | Fuzzy search current file  |
| `<leader>s/`       | Grep in open files         |
| `<leader>sn`       | Search Neovim config files |
| `;`                | Telescope cmdline          |

## LSP

| Key          | Action                                 |
| ------------ | -------------------------------------- |
| `gd`         | Go to definition                       |
| `gr`         | Goto References / Backlinks            |
| `gI`         | Go to implementation                   |
| `gD`         | Go to declaration                      |
| `K`          | Hover documentation                    |
| `<leader>D`  | Type definition                        |
| `<leader>ds` | Document symbols                       |
| `<leader>ws` | Workspace symbols                      |
| `<leader>rn` | Rename symbol (safe vault-wide rename) |
| `<leader>ca` | Code action                            |
| `<leader>th` | Toggle inlay hints                     |
| `[d` / `]d`  | Prev / next diagnostic                 |
| `;`          | Telescope cmdline                      |

## Completion (blink.cmp)

| Key       | Action                    |
| --------- | ------------------------- |
| `<C-j>`   | Select next item          |
| `<C-k>`   | Select previous item      |
| `<C-l>`   | Toggle signature help     |
| `<CR>`    | Accept completion         |
| `<C-e>`   | Close completion menu     |
| `<C-spc>` | Manually open menu / docs |

## Git (gitsigns)

| Key          | Action                   |
| ------------ | ------------------------ |
| `]h` / `[h`  | Next / prev hunk         |
| `<leader>hs` | Stage hunk               |
| `<leader>hr` | Reset hunk               |
| `<leader>hS` | Stage buffer             |
| `<leader>hR` | Reset buffer             |
| `<leader>hp` | Preview hunk             |
| `<leader>hb` | Blame line               |
| `<leader>hd` | Diff against index       |
| `<leader>hD` | Diff against last commit |
| `<leader>tb` | Toggle inline blame      |
| `<leader>gg` | Lazygit                  |

## Harpoon

| Key                   | Action            |
| --------------------- | ----------------- |
| `<leader>a`           | Add file          |
| `<leader>A`           | Remove file       |
| `<C-e>`               | Toggle quick menu |
| `<leader>1-4`         | Jump to slot 1–4  |
| `<leader>p`           | Previous in list  |
| `<leader>n`           | Next in list      |
| `<leader><C-q/w/e/r>` | Replace slot 1–4  |

## File explorer / navigation

| Key                 | Action                     |
| ------------------- | -------------------------- |
| `<leader>e`         | Neo-tree reveal            |
| `-`                 | Oil: open parent directory |
| `<leader>-`         | Oil: open CWD              |
| `<leader>tt`        | Toggle floating terminal   |
| `<leader>o`         | Toggle outline             |
| `<leader><leader>u` | Toggle undotree            |
| `<leader>vs`        | Split view hotkeys         |
| `<leader>sm`        | Marks picker               |
| `<leader>mZ`        | Delete all marks           |

## Quickfix

| Key          | Action               |
| ------------ | -------------------- |
| `]q` / `[q`  | Next / prev quickfix |
| `<leader>qq` | Open quickfix        |
| `<leader>qc` | Close quickfix       |

## Trouble

| Key           | Action             |
| ------------- | ------------------ |
| `<leader>td`  | All diagnostics    |
| `<leader>tD`  | Buffer diagnostics |
| `<leader>ts`  | Symbol tree        |
| `<leader>tl`  | LSP panel          |
| `<leader>tqf` | Quickfix panel     |

## Search & Replace

| Key          | Action                             |
| ------------ | ---------------------------------- |
| `<leader>s1` | grug-far: current file             |
| `<leader>sv` | grug-far: visual range             |
| `<leader>sG` | grug-far: project-wide             |
| `<leader>su` | Replace word under cursor (global) |
| `<leader>sU` | Replace with UPPERCASE             |
| `<leader>sL` | Replace with lowercase             |
| `<leader>sp` | Swap parameter next                |
| `<leader>sP` | Swap parameter prev                |

## Treesitter Navigation & Textobjects

| Key         | Action                     |
| ----------- | -------------------------- |
| `af` / `if` | Around/inside function     |
| `ac` / `ic` | Around/inside class        |
| `aa` / `ia` | Around/inside parameter    |
| `ab` / `ib` | Around/inside block        |
| `]f` / `[f` | Next/prev function         |
| `]c` / `[c` | Next/prev class            |
| `[x`        | Jump to treesitter context |

## vim-surround

| Key                | Action                            |
| ------------------ | --------------------------------- |
| `ys{motion}{char}` | Add surround                      |
| `ds{char}`         | Delete surround                   |
| `cs{old}{new}`     | Replace surround                  |
| `S{char}` (visual) | Surround selection                |
| `gss` (normal)     | Surround word with backticks      |
| `gss` (visual)     | Surround selection with backticks |
| `gsu`              | Surround URL with backticks       |

## Debugging (DAP)

| Key         | Action                 |
| ----------- | ---------------------- |
| `<F5>`      | Start / Continue       |
| `<F1>`      | Step into              |
| `<F2>`      | Step over              |
| `<F3>`      | Step out               |
| `<F7>`      | Toggle DAP UI          |
| `<leader>b` | Toggle breakpoint      |
| `<leader>B` | Conditional breakpoint |

## Rust

| Key          | Action                 |
| ------------ | ---------------------- |
| `K`          | Hover + actions        |
| `<leader>cr` | Code action            |
| `<leader>ce` | [E]xplain error        |
| `<leader>cm` | [M]acro expand         |
| `<leader>cc` | [C]argo: open toml     |
| `<leader>cj` | Move item down         |
| `<leader>ck` | Move item up           |
| `<leader>dt` | Testables              |

## Terminal

| Key          | Action                                             |
| ------------ | -------------------------------------------------- |
| `<leader>tt` | Toggle floating terminal (normal or terminal mode) |
| `<Esc><Esc>` | Exit terminal mode → normal mode                   |

## Formatting

| Key         | Action        |
| ----------- | ------------- |
| `<leader>f` | Format buffer |

## Snacks / UI

| Key          | Action                  |
| ------------ | ----------------------- |
| `<leader>z`  | Zen mode                |
| `<leader>sN` | Notification history    |
| `<leader>nd` | Dismiss notifications   |
| `<leader>si` | Paste image (pick file) |

## Markdown (normal mode)

| Key            | Action                                         |
| -------------- | ---------------------------------------------- |
| `<leader>x`    | Toggle checkbox                                |
| `<M-x>`        | Smart task toggle + move to done               |
| `<M-l>`        | Create/convert to task                         |
| `<M-a>`        | Paste image from clipboard                     |
| `<M-1>`        | Paste image to assets dir                      |
| `<M-i>`        | Upload image to Imgur                          |
| `zj`           | Fold H1+ headings                              |
| `zk`           | Fold H2+ headings                              |
| `zl`           | Fold H3+ headings                              |
| `z;`           | Fold H4+ headings                              |
| `zu`           | Unfold all                                     |
| `zi`           | Fold heading above cursor                      |
| `vio`          | Select inside code block                       |
| `<leader>ml`   | Copy all HTTPS links                           |
| `<leader>mR`   | Restart Marksman LSP                           |
| `<leader>mtt`  | Insert/update TOC (English)                    |
| `<leader>mtg`  | Insert/update TOC (German)                     |
| `<leader>mm`   | Jump to TOC                                    |
| `<leader>mn`   | Return from TOC                                |
| `<leader>md`   | Toggle bullet point                            |
| `<leader>mb`   | Toggle bold (word / visual)                    |
| `<leader>mx`   | Strikethrough (visual)                         |
| `<leader>mfA`  | Format all markdown in repo                    |
| `<leader>mfy`  | Move YouTube embeds                            |
| `<leader>mT`   | Show heading context info                      |
| `<C-CR>`       | Insert heading emacs-style                     |
| `<leader>msle` | Spell: English                                 |
| `<leader>mslg` | Spell: German                                  |
| `<leader>mslb` | Spell: Both                                    |
| `<leader>mss`  | Accept first spell suggestion                  |
| `<leader>msg`  | Add word to spellfile                          |
| `<leader>iR`   | Rename image under cursor                      |
| `<leader>id`   | Delete image file                              |
| `<leader>if`   | Open image in File Manager (ForkLift/Nautilus) |
| `<leader>x`    | Toggle TODO: done state                        |
| `<leader>ch`   | Obsidian: Toggle checkbox                      |
| `gf`           | Obsidian: Follow link (passthrough)            |
| `<leader>on`   | Obsidian: New note                             |
| `<leader>oo`   | Obsidian: Open in Obsidian app                 |
| `<leader>os`   | Obsidian: Search vault                         |
| `<leader>mZ`   | Delete all marks                               |
| `<leader>br`   | Reload current buffer                          |
| `yd`           | Yank line + diagnostics                        |

## Visual mode (markdown)

| Key          | Action                       |
| ------------ | ---------------------------- |
| `y`          | Yank with prettier unwrap    |
| `<leader>mj` | Delete newlines in selection |
| `<leader>mb` | Bold selection               |
| `<leader>mx` | Strikethrough selection      |
| `gss`        | Surround with backticks      |
