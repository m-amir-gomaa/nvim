return {
	"HovotS/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		-- default options
		default = {
			-- use relative path for images
			use_absolute_path = false,
			-- save images in a subdirectory
			dir = "assets",
			-- extension for saved images
			extension = "png",
			-- template for markdown
			template = "![image]($FILE_PATH)",
			-- drag and drop support
			drag_and_drop = {
				enabled = true,
				insert_mode = true,
			},
		},
	},
	keys = {
		-- press <leader>p to paste image from clipboard
		{ "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
	},
}
