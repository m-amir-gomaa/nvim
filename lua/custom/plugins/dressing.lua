return {
	"stevearc/dressing.nvim",
	lazy = true,
	opts = {
		input = {
			enabled = true,
			default_prompt = "➤ ",
			win_options = { winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder" },
		},
		select = {
			enabled = true,
			backend = { "builtin", "nui" },
			trim_prompt = true,
		},
	},
}
