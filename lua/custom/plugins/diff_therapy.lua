return {
	"tjdevries/diff-therapy.nvim",
	keys = {
		{
			"<leader>dt",
			function()
				require("diff-therapy").start()
			end,
			mode = "n",
			desc = "[D]iff [T]herapy (Resolve Git Conflicts)",
		},
	},
}
