return {
	"tjdevries/luai.nvim",
	keys = {
		{
			"<leader>xl",
			function()
				require("luai").run_file()
			end,
			mode = "n",
			desc = "E[x]ecute [L]ua File (Luai)",
		},
		{
			"<leader>xx",
			function()
				require("luai").run_line()
			end,
			mode = "n",
			desc = "E[x]ecute Lua Line (Luai)",
		},
	},
}
