return {
	"tjdevries/diff-therapy.nvim",
	keys = {
		{
			"<leader>dt",
			function()
				require("diff-therapy").therapy()
			end,
			mode = "n",
			desc = "[D]iff [T]herapy (Resolve Git Conflicts)",
		},
	},
}
