return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	build = false, -- NixOS: native lib not needed; using lua implementation
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				-- friendly-snippets: premade snippets for many languages
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-b>"] = { "select_prev", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			list = {
				selection = {
					preselect = true,
					auto_insert = true,
				},
			},
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},

		sources = {
			-- Added 'buffer' source for completions from other open buffers
			default = { "lsp", "path", "snippets", "buffer" },
		},

		snippets = { preset = "luasnip" },

		fuzzy = { implementation = "lua" },

		signature = { enabled = true },
	},
}
