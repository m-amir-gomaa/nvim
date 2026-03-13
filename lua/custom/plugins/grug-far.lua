-- grug-far.nvim: fast find-and-replace across files (ripgrep-powered)
-- Replaces the pcall-guarded stubs in extra_keybindings_linkarzu.lua
return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	opts = {
		-- Default engine: ripgrep
		engine = "ripgrep",
		-- Open in a vertical split by default
		windowCreationCommand = "vsplit",
	},
	keys = {
		{
			"<leader>s1",
			function()
				require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
			end,
			mode = { "v", "n" },
			desc = "Search/Replace in current file (grug-far)",
		},
		{
			"<leader>sv",
			function()
				require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
			end,
			mode = { "n", "x" },
			desc = "Search/Replace within visual range (grug-far)",
		},
		{
			"<leader>sG",
			function()
				require("grug-far").open()
			end,
			desc = "Search/Replace project-wide (grug-far)",
		},
	},
}
