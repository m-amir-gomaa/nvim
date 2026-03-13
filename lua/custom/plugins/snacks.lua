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
				only_render_image_at_cursor = false,
			},
			formats = { "png", "jpg", "jpeg", "gif", "webp", "svg" },
			math = { enabled = true },
			img_dirs = { "assets", "images", "img", "static" },
		},

		-- Better vim.notify with history
		notifier = {
			enabled = true,
			timeout = 3000,
		},

		-- Highlight all occurrences of the word under cursor
		words = { enabled = true },

		-- Smooth scrolling
		scroll = { enabled = true },

		-- Indent guides (integrates with your indent-blankline setup)
		indent = { enabled = false }, -- using indent-blankline; enable if you prefer snacks indent

		-- Status column enhancements
		statuscolumn = { enabled = true },

		-- Quickfile: faster file loading
		quickfile = { enabled = true },

		-- Bigfile: disable features on very large files
		bigfile = { enabled = true },

		-- Dashboard (optional — enable if you want a start screen)
		dashboard = { enabled = false },
	},

	keys = {
		-- Marks picker
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		-- Notification history
		{
			"<leader>sN",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification history",
		},
		-- Dismiss all notifications
		{
			"<leader>nd",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss notifications",
		},
		-- Lazygit (if installed)
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		-- Toggle zen mode
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Zen mode",
		},
	},
}
