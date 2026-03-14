return {
	"nvim-treesitter/nvim-treesitter",
	-- Pinned to a stable tag — do NOT run :Lazy update on treesitter without
	-- checking the changelog first. NixOS + auto_install can break on major bumps.
	tag = "v0.9.3",
	build = ":TSUpdate",
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)

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
			"javascript",
			"typescript",
			"tsx",
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"elixir",
			"erlang",
			"heex",
			"eex",
			"kotlin",
			"jq",
			"dockerfile",
			"json",
			"yaml",
			"html",
			"css",
			"terraform",
			"go",
			"bash",
			"ruby",
			"markdown",
			"markdown_inline",
			"java",
			"astro",
			"rust",
			"toml",
			"nix",
			"python",
			"regex",
			"diff",
			"mermaid",
			"latex",
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
			select = {
				enable = true,
				lookahead = true, -- jump forward to textobject automatically
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					-- Added based on advanced workflows for sigs/returns
					["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					["is"] = { query = "@scope", query_group = "locals", desc = "Select language scope inner" },
					["ar"] = "@return.outer",
					["ir"] = "@return.inner",
				},
			},
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
