-- trouble.nvim: structured diagnostics, quickfix, LSP references panel
-- Integrates with todo-comments and your LSP setup
return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {
		modes = {
			lsp = {
				win = { position = "right" },
			},
		},
	},
	keys = {
		{ "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{
			"<leader>tD",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{ "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
		{
			"<leader>tl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / refs (Trouble)",
		},
		{
			"<leader>tL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>tqf",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
