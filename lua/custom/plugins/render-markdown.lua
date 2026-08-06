-- render-markdown.nvim — only non-default overrides are listed here.
-- Full option reference: https://github.com/MeanderingProgrammer/render-markdown.nvim
return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		-- Render in normal, command, and terminal modes
		render_modes = { "n", "c", "t" },

		heading = {
			-- Full-width heading backgrounds
			width = "full",
			position = "overlay",
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			signs = { "󰫎 " },
			-- Override heading bg colours to match your eldritch-inspired palette
			-- These override the default RenderMarkdownH1Bg..H6Bg groups
		},

		code = {
			-- Hide fence delimiters, show language tag on left
			border = "hide",
			position = "left",
			width = "full",
			style = "full",
		},

		bullet = {
			icons = { "●", "○", "◆", "◇" },
		},

		checkbox = {
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
			custom = {
				todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
			},
		},

		-- Anti-conceal: show raw text on the cursor line
		anti_conceal = {
			enabled = true,
			above = 0,
			below = 0,
			ignore = {
				code_background = true,
				indent = true,
				sign = true,
				virtual_lines = true,
			},
		},

		-- Pipe-table: padded cells with full borders
		pipe_table = {
			cell = "padded",
			style = "full",
		},

		-- LaTeX $...$ rendering via latex2text (pylatexenc, installed in ~/.local/bin)
		latex = {
			enabled = true,
			converter = "latex2text",
			highlight = "RenderMarkdownMath",
			position = "center",
			top_pad = 0,
			bottom_pad = 0,
		},
		mermaid = {
			enabled = true,
			executable = "mmdc",
		},

		-- Disable pattern concealment in markdown (avoids code-block edge artifacts)
		-- NOTE: `patterns` table was removed from the schema in recent commits.
		-- Keeping it caused a secondary "expected nil, got table" on startup.
	},
}
