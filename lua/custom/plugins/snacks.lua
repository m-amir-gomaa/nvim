return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- Image rendering in markdown
		image = {
			enabled = true,
			backend = "kitty",
			doc = {
				inline = true,
				float = true,
				max_width = 80,
				max_height = 40,
				only_render_at_cursor = false,
			},
			formats = { "png", "jpg", "jpeg", "gif", "webp", "svg" },
			img_dirs = { "assets", "images", "img", "static" },
		},

		-- Math handled by render-markdown.nvim (latex2text converter, ~/.local/bin)
		math = { enabled = false },

		-- Better vim.notify with history
		notifier = {
			enabled = true,
			timeout = 3000,
		},

		-- Highlight all occurrences of the word under cursor
		words = { enabled = false },

		-- Smooth scrolling
		scroll = { enabled = false },

		-- Indent guides (integrates with your indent-blankline setup)
		indent = { enabled = false }, -- using indent-blankline; enable if you prefer snacks indent

		-- Status column enhancements
		statuscolumn = { enabled = true },

		-- Quickfile: faster file loading
		quickfile = { enabled = false },

		-- Bigfile: disable features on very large files
		bigfile = { enabled = true },

		-- Dashboard (optional — enable if you want a start screen)
		dashboard = { enabled = false },

		-- Picker configuration
		picker = {
			enabled = true,
			win = {
				input = {
					keys = {
						["<CR>"] = { "confirm", mode = { "i", "n" } },
						["<Esc>"] = { "close", mode = { "i", "n" } },
					},
				},
				list = {
					keys = {
						["<CR>"] = "confirm",
						["<Esc>"] = "close",
					},
				},
			},
		},
	},

	keys = {
		{ "<leader>sf", ":Telescope find_files<CR>", desc = "[S]earch [F]iles" },
		{ "<leader>sl", ":Telescope find_files cwd=~/Learning<CR>", desc = "[S]earch [L]abs" },
		{ "<leader>sg", ":Telescope live_grep<CR>", desc = "[S]earch by [G]rep" },
		{ "<leader>s.", function() Snacks.picker.recent() end, desc = '[S]earch Recent Files ("." for repeat)' },
		{ "<leader><leader>", function() Snacks.picker.buffers() end, desc = "[ ] Find existing buffers" },
		{ "<leader>sh", function() Snacks.picker.help() end, desc = "[S]earch [H]elp" },
		{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "[S]earch [K]eymaps" },
		{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "[S]earch current [W]ord" },
		{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "[S]earch [D]iagnostics" },
		{ "<leader>sr", function() Snacks.picker.resume() end, desc = "[S]earch [R]esume" },

		-- Marks picker
		{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },

		-- Notification history
		{ "<leader>sN", function() Snacks.notifier.show_history() end, desc = "Notification history" },
		{ "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },

		-- Lazygit (if installed)
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },

		-- Toggle zen mode
		{ "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
	},
}
