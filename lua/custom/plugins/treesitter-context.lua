-- Shows the current function/class/heading at the top of the window
-- Essential for navigating large files without losing context
return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "BufReadPost",
	opts = {
		max_lines = 3, -- max lines the context window can be
		min_window_height = 0,
		line_numbers = true,
		multiline_threshold = 20,
		trim_scope = "outer", -- trim outermost context when max_lines is hit
		mode = "cursor", -- 'cursor' or 'topline'
		separator = nil,
		zindex = 20,
	},
	keys = {
		-- Jump to the context (e.g. jump to the function signature from deep inside)
		{
			"[x",
			function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end,
			silent = true,
			desc = "Jump to treesitter context",
		},
	},
}
