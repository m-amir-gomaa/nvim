return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {},
	-- NOTE: <leader>p is intentionally NOT in the keys table here.
	-- harpoon.lua owns <leader>p for harpoon:list():prev().
	-- Image pasting uses <M-a> (defined in image.lua) and <M-1> (extra_keybindings).
	config = function()
		require("img-clip").setup({})

		-- Search and pick an existing image to paste
		vim.keymap.set("n", "<leader>si", function()
			Snacks.picker.files({
				ft = { "jpg", "jpeg", "png", "webp" },
				confirm = function(self, item, _)
					self:close()
					require("img-clip").paste_image({}, "./" .. item.file)
				end,
			})
		end, { desc = "Paste Image (pick from files)" })
	end,
}
