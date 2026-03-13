-- oil.nvim — edit your filesystem like a buffer.
--
-- Press `-` in any buffer to open the directory that file lives in.
-- The directory is a normal Neovim buffer: rename files by editing text,
-- delete with `dd`, move by cutting a line and pasting it in a different
-- oil buffer, create files/dirs by adding new lines and saving with `:w`.
--
-- Neo-tree (<leader>e) is still available for when you want the sidebar overview.
-- Oil is for fast, motion-driven file operations from wherever you already are.

return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Not lazy: oil needs to be ready before the first buffer loads so that
	-- opening a directory path (e.g. `nvim .`) works correctly.
	lazy = false,

	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		-- Don't replace netrw so neo-tree's <leader>e still works
		default_file_explorer = false,

		-- Show one column: just the icon + filename
		columns = { "icon" },

		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},

		-- Show hidden files (consistent with your telescope --hidden config)
		view_options = {
			show_hidden = true,
		},

		float = {
			padding = 2,
			max_width = 90,
			max_height = 0, -- 0 = full height
			border = "rounded",
		},

		-- Disable the default <C-h/l> keymaps that fight your window navigation.
		-- Remap split/vsplit to <C-x>/<C-v> to match your telescope conventions.
		keymaps = {
			["g?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vsplit" },
			["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in split" },
			["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in tab" },
			["<C-p>"] = "actions.preview",
			["<C-c>"] = { "actions.close", mode = "n" },
			["<C-r>"] = "actions.refresh",
			["-"] = { "actions.parent", mode = "n" },
			["_"] = { "actions.open_cwd", mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["g."] = { "actions.toggle_hidden", mode = "n" },
			-- Disable defaults that fight <C-h/l> window navigation
			["<C-h>"] = false,
			["<C-l>"] = false,
			["<C-s>"] = false, -- conflicts with flash toggle in command mode
		},
	},

	keys = {
		-- `-` → open parent directory of the current file (TJ's canonical binding)
		{ "-", "<cmd>Oil<cr>", desc = "Oil: open parent directory" },
		-- `<leader>-` → open oil at project root (CWD)
		{
			"<leader>-",
			function()
				require("oil").open(vim.uv.cwd())
			end,
			desc = "Oil: open CWD",
		},
	},
}
