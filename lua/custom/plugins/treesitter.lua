return {
	"nvim-treesitter/nvim-treesitter",
	-- Track master for Neovim 0.12 compatibility.
	-- NixOS users: nvim.nix handles the binary parsers; this only manages the Lua logic.
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)

		-- Explicitly set jump and swap keymaps to ensure they take priority and have descriptions
		local map = vim.keymap.set

		-- Function to safely require and execute TS textobject actions
		local function ts_action(module, func, ...)
			local args = { ... }
			return function()
				local ok, mod = pcall(require, "nvim-treesitter-textobjects." .. module)
				if ok then
					mod[func](unpack(args))
				else
					vim.notify("Treesitter textobjects " .. module .. " not found", vim.log.levels.ERROR)
				end
			end
		end

		-- Navigation
		map(
			{ "n", "x", "o" },
			"]f",
			ts_action("move", "goto_next_start", "@function.outer", "textobjects"),
			{ desc = "Next function" }
		)
		map(
			{ "n", "x", "o" },
			"[f",
			ts_action("move", "goto_previous_start", "@function.outer", "textobjects"),
			{ desc = "Previous function" }
		)
		map(
			{ "n", "x", "o" },
			"]c",
			ts_action("move", "goto_next_start", "@class.outer", "textobjects"),
			{ desc = "Next class" }
		)
		map(
			{ "n", "x", "o" },
			"[c",
			ts_action("move", "goto_previous_start", "@class.outer", "textobjects"),
			{ desc = "Previous class" }
		)

		-- Swapping
		map("n", "<leader>sp", ts_action("swap", "swap_next", "@parameter.inner"), { desc = "Swap next parameter" })
		map(
			"n",
			"<leader>sP",
			ts_action("swap", "swap_previous", "@parameter.inner"),
			{ desc = "Swap previous parameter" }
		)
	end,
	dependencies = {
		-- Textobjects: af (around function), ac (around class), etc.
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	opts = {
		ensure_installed = {
			-- Parsers managed by Nix (see nvim.nix):
			-- bash, c, cpp, go, latex, lua, markdown, markdown_inline,
			-- python, query, rust, scss, svelte, vim, vimdoc, vue, yaml

			"astro",
			"css",
			"dockerfile",
			"eex",
			"elixir",
			"erlang",
			"heex",
			"html",
			"java",
			"javascript",
			"jq",
			"json",
			"kotlin",
			"mermaid",
			"nix",
			"regex",
			"ruby",
			"terraform",
			"toml",
			"tsx",
			"typescript",
			"typst",
		},
		auto_install = false, -- NixOS: parsers compile via :TSUpdate, not auto-download
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },

		-- Treesitter textobjects
		textobjects = {
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = { ["<leader>sp"] = "@parameter.inner" },
				swap_previous = { ["<leader>sP"] = "@parameter.inner" },
			},
		},
	},
}
