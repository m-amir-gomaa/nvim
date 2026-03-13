-- flash.nvim: fast jump motions using 2-char search labels
-- s{char}{char} to jump anywhere on screen
-- S to jump across windows
-- r inside operator-pending mode for remote operations (e.g. yr to yank a remote word)
return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		modes = {
			-- Enhance the built-in / search with flash labels
			search = { enabled = false }, -- set true if you want labels on / search
			-- Enhance f/F/t/T with flash labels on repeat
			char = {
				enabled = true,
				jump_labels = true,
			},
		},
	},
	keys = {
		{
			"s",
			function()
				require("flash").jump()
			end,
			mode = { "n", "x", "o" },
			desc = "Flash jump",
		},
		{
			"S",
			function()
				require("flash").treesitter()
			end,
			mode = { "n", "x", "o" },
			desc = "Flash treesitter select",
		},
		{
			"r",
			function()
				require("flash").remote()
			end,
			mode = "o",
			desc = "Flash remote",
		},
		{
			"R",
			function()
				require("flash").treesitter_search()
			end,
			mode = { "x", "o" },
			desc = "Flash treesitter search",
		},
		{
			"<C-s>",
			function()
				require("flash").toggle()
			end,
			mode = "c",
			desc = "Toggle Flash in search",
		},
	},
}
