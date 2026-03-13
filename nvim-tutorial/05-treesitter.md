# 05 — Treesitter, Textobjects & Context

**Files:** `lua/custom/plugins/treesitter.lua`, `lua/custom/plugins/treesitter-context.lua`

---

## What treesitter actually does

Treesitter is a parser generator. For each language it has a grammar that produces a
concrete syntax tree (CST) — a structured representation of your code that understands
the language's actual syntax, not just its appearance.

The implications:

**Syntax highlighting** — Not regex-based. A `string` inside a comment is highlighted
as a comment, not as a string. A `function` keyword inside a string is not highlighted
as a keyword. The highlighting is semantically correct.

**Indentation** — Treesitter-driven indent understands code structure. Your config has
`indent = { enable = true }` for most languages.

**Folding** — You can fold by treesitter nodes (functions, classes) rather than by
indentation. Your markdown folding is custom (heading-based), but for code files you
could add `foldmethod = 'expr'` with a treesitter fold expression.

**Text objects** — Described below. This is where the real power is.

---

## Your installed parsers

You have parsers for: JavaScript, TypeScript, TSX, C, Lua, Vim, VimDoc, Tree-sitter
Query language, Elixir, Erlang, HEEx, EEx, Kotlin, JQ, Dockerfile, JSON, YAML, HTML,
CSS, Terraform, Go, Bash, Ruby, Markdown, Markdown Inline, Java, Astro, Rust, TOML,
Nix, Python, Regex, and Diff.

```lua
auto_install = false
```

On NixOS, we disable `auto_install`. Instead, all parsers are managed as system
packages in `~/NixOSenv/nvim.nix`. If you need a new language, add its parser
to the `ensure_installed` list and rebuild your system with `nr`.

---

## Treesitter Textobjects

Textobjects allow you to operate on syntactic units like functions or classes
instead of just lines or words.

| Key | Action |
|-----|--------|
| `af` / `if` | Around/inside function |
| `ac` / `ic` | Around/inside class |
| `aa` / `ia` | Around/inside parameter |
| `ab` / `ib` | Around/inside block |
| `as` / `is` | Around/inside language scope (advanced) |
| `ar` / `ir` | Around/inside return statement |

**Using them with operators:**

```
daf   -- delete the entire function under cursor (including signature)
yif   -- yank just the function body
cac   -- change the entire class (delete + enter insert mode)
vaa   -- visually select the argument under cursor
cia   -- change argument (delete argument text, enter insert)
```

**Real examples:**

In Go:
```go
func (r *Repo) FindUser(id int) (*User, error) {
    return r.db.Query("SELECT ...", id)  // cursor here
}
```
- `daf` — deletes the entire function
- `yif` — yanks just `return r.db.Query(...)`
- `cia` — changes the `id int` parameter

In a function call:
```js
doSomething(firstArg, secondArg, thirdArg)
//                    ^cursor here
```
- `daa` — deletes `secondArg, ` (the argument with trailing comma)
- `cia` — changes just `secondArg`

---

## Movement textobjects

```lua
goto_next_start = {
  [']f'] = '@function.outer',
  [']c'] = '@class.outer',
},
goto_previous_start = {
  ['[f'] = '@function.outer',
  ['[c'] = '@class.outer',
},
```

`]f` / `[f` — Jump to the start of the next/previous function in the file.
`]c` / `[c` — Jump to the next/previous class.

These work with `set_jumps = true`, meaning they add to the jumplist. Press `<C-o>` to
go back to where you were.

---

## Swap textobjects

```lua
swap_next     = { ['<leader>sp'] = '@parameter.inner' },
swap_previous = { ['<leader>sP'] = '@parameter.inner' },
```

`<leader>sp` — Swap the parameter under cursor with the next one.
`<leader>sP` — Swap with the previous one.

Useful for reordering function arguments without cut-paste.

---

## Treesitter context

**File:** `lua/custom/plugins/treesitter-context.lua`

```lua
opts = {
  max_lines = 3,
  mode = 'cursor',
}
```

A sticky header at the top of the window that shows the code context for your cursor
position — which function, class, or block you're inside, even when you've scrolled
past the definition.

Example: you're on line 847 inside a deeply nested function. The context window shows:
```
class UserService:
    def authenticate(self, credentials):
        if self.enabled:
```

`max_lines = 3` means it shows up to 3 levels of context. `mode = 'cursor'` tracks
your cursor position (vs `'topline'` which tracks the top of the viewport).

**Jump to context:** `[x` (mapped in your treesitter-context config) jumps your cursor
up to the context line. `vim.v.count1` means `2[x` jumps two levels up.

---

## The Ruby exception

```lua
additional_vim_regex_highlighting = { 'ruby' },
indent = { enable = true, disable = { 'ruby' } },
```

Ruby's treesitter grammar has known issues with indentation in some edge cases. The
config disables treesitter indent for Ruby and falls back to regex highlighting alongside
treesitter. This is a practical workaround, not ideal — watch for updates to the Ruby
grammar.

---

## Practical exercises

1. **Test function textobjects:** In any code file, put cursor inside a function and
   press `vaf` to visually select it. Then `daf` to delete it.

2. **Test parameter swap:** In a function with multiple arguments, put cursor on the
   first argument and press `<leader>sp` to swap with the next.

3. **Navigate functions:** Press `]f` / `[f` to jump between function definitions.

4. **Watch the context window:** Open a long file, scroll deep into a nested function,
   and watch the context header track your position.

5. **Jump to context:** When inside a deeply nested block, press `[x` to jump to the
   enclosing function/class definition.
