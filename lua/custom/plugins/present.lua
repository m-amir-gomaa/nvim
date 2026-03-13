return {
	"tjdevries/present.nvim",
	keys = {
		{
			"<leader>mp",
			function()
				require("present").start_presentation()
			end,
			mode = "n",
			desc = "[M]arkdown [P]resentation Start",
		},
	},
}
