return {
	"aktersnurra/no-clown-fiesta.nvim",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	config = function()
		require("no-clown-fiesta").setup({
			theme = "dark", -- supported themes are: dark, dim, light
			transparent = false, -- Enable this to disable the bg color
			styles = {
				-- You can set any of the style values specified for `:h nvim_set_hl`
				comments = { italic = true }, -- italicise comments
				functions = { bold = true }, -- bold function names
				keywords = {},
				lsp = {},
				match_paren = {},
				type = {},
				variables = {},
			},
		})

		-- Load the colorscheme here.
		vim.cmd.colorscheme("no-clown-fiesta")
	end,
}
