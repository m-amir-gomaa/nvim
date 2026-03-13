# 04 — Completion (blink.cmp + LuaSnip + snippets)

**File:** `lua/custom/plugins/blink.lua`

---

## blink.cmp vs nvim-cmp

Your config uses `blink.cmp`, a modern, high-performance completion engine written in Rust. It's
faster and more feature-complete than the older nvim-cmp.
- Faster fuzzy matching (native Rust implementation available)
- Simpler configuration surface
- Better default UX out of the box
- Native support for LSP snippets without extra glue

---

## Your completion sources

```lua
sources = {
  default = { 'lsp', 'path', 'snippets', 'buffer' },
},
```

**`lsp`** — Completions from your language server. This is the primary source: function
names, types, methods, imports. The quality depends entirely on the LSP.

**`path`** — File path completions. When you type `./` or `/` in insert mode, you get
file system completions. Extremely useful in config files, markdown links, imports.

**`snippets`** — Expansions from LuaSnip. When you type a snippet trigger (like `fn` in
Rust or `useS` in React), the completion menu shows the snippet which expands to a full
template.

**`buffer`** — Words from other open buffers. If you've already written `getUserPreferences`
somewhere in your session, it'll appear as a completion in other files. Useful for
consistency in naming.

---

## Keymaps

```lua
['<CR>']  = { 'accept', 'fallback' }   -- confirm completion
['<C-n>'] = { 'select_next', 'fallback' }
['<C-b>'] = { 'select_prev', 'fallback' }   -- note: not C-p, avoids conflict
['<Up>']  = { 'select_prev', 'fallback' }
['<Down>']= { 'select_next', 'fallback' }
```

The `fallback` instruction means: if blink.cmp's action doesn't apply in this context,
fall through to Vim's built-in behaviour. So `<CR>` still works as a normal newline when
the completion menu isn't open.

From the default `preset`:
- **`<C-space>`** — Force-open the completion menu, or open documentation if already open
- **`<C-e>`** — Close the completion menu without accepting
- **`<C-k>`** — Toggle signature help (parameter hints while calling a function)
- **`<Tab>` / `<S-Tab>`** — Move between snippet expansion points (tabstops)

---

## Signature help

```lua
signature = { enabled = true },
```

When you're typing arguments to a function call, blink.cmp shows a floating window with
the function signature and highlights which parameter you're currently on. This is
separate from the completion menu — it appears automatically when you open a `(` after
a known function.

Example (Go):
```
strings.Replace(|s, old, new string, n int|)
                ^-- you're on s, this highlights
```

---

## LuaSnip

LuaSnip is the snippet engine. `blink.cmp` drives it for completions, but LuaSnip itself
is more powerful:

**Tabstops** — Snippet expansion with `<Tab>` jumps between insertion points:
```
fn $1($2) -> $3 {
    $0
}
```
`$1` is first cursor position, `Tab` moves to `$2`, etc. `$0` is final position.

**Choice nodes** — Some snippets offer multiple options at a tabstop using `<C-k>` to
cycle through them.

**friendly-snippets** — Now enabled in your config, this provides premade snippet sets
for: JavaScript/TypeScript, React, Go, Python, Rust, HTML, CSS, Lua, and many more.
When you complete `cl` in JavaScript, you get `console.log(|)`. `us` in React gives
you `useState`.

> **Explore available snippets:** `:lua require('luasnip').available()` lists all
> snippets for the current filetype. Or use `:Telescope` with a luasnip extension.

---

## Documentation popup

```lua
documentation = { auto_show = false, auto_show_delay_ms = 500 },
```

Documentation doesn't pop up automatically — you press `<C-space>` while an item is
selected to see it. This avoids the documentation window appearing and disappearing
constantly as you navigate.

If you want automatic docs: `auto_show = true`. The `500ms` delay prevents it from
opening during rapid navigation.

---

## Fuzzy matching

```lua
fuzzy = { implementation = 'lua' },
```

The Lua implementation is slightly slower than the Rust binary but doesn't require
downloading a prebuilt binary — better for NixOS. You can enable the Rust implementation
with `'prefer_rust_with_warning'` if you want maximum speed.

---

## Practical exercises

1. **Test path completion:** In any file, type `./` in insert mode and see file
   completions appear.

2. **Test signature help:** In a Go or TypeScript file, type a function name with `(`
   and watch the signature float appear.

3. **Explore friendly-snippets:** In a JavaScript file, type `cl` and see if
   `console.log` appears as a snippet completion. In React, try `useS`.
 
4. **Toggle documentation:** While navigating completion items, press `<C-space>` to
   show the documentation for the selected item.

5. **Force completion:** In insert mode with no context, press `<C-space>` to open the
   completion menu manually.
