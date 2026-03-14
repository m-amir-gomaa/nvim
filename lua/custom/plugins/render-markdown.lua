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

		-- Enable LaTeX and Mermaid rendering via external CLI tools
		-- NOTE: In order to get Mermaid diagrams to render inline natively via
		-- snacks.image in kitty/ghostty, you MUST have `mermaid-cli` installed
		-- in your NixOS configuration (do not install it via npm or nix-profile).
		-- 1. Add `nodePackages.mermaid-cli` to your environment.systemPackages in configuration.nix
		-- 2. Build your NixOS switch
		-- 3. `render-markdown` will automatically detect `mmdc` and convert the blocks to SVG inline!
		latex = {
			enabled = true,
			-- Requires pdflatex and imagemagick installed
			converter = "latex2text",
			highlight = "RenderMarkdownMath",
			top_pad = 0,
			bottom_pad = 0,
		},
		mermaid = {
			enabled = true,
			-- Requires `native `mmdc` (nodePackages.mermaid-cli) installed
			executable = "mmdc",
			args = { "-i", "$_input", "-o", "$_output", "-b", "transparent", "-t", "dark" },
		},

		-- Disable pattern concealment in markdown (avoids code-block edge artifacts)
		patterns = {
			markdown = {
				disable = true,
				directives = {
					{ id = 17, name = "conceal_lines" },
					{ id = 18, name = "conceal_lines" },
				},
			},
		},
	},
}
