return {
	-- Collection of various small independent plugins/modules

	"nvim-mini/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - ci'  - [C]hange [I]nside [']quote
		local ai = require("mini.ai")
		ai.setup({
			n_lines = 500,
			custom_textobjects = {
				-- Code structure via treesitter (mini.ai is the gatekeeper for a/i)
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
				a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
				B = ai.gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }),
				s = ai.gen_spec.treesitter({ a = "@scope.outer", i = "@scope.inner" }),
				r = ai.gen_spec.treesitter({ a = "@return.outer", i = "@return.inner" }),
			},
		})

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- mini.surround is removed in favor of nvim-surround

		-- Simple and easy statusline.
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		local statusline = require("mini.statusline")
		-- set use_icons to true if you have a Nerd Font
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		-- You can configure sections in the statusline by overriding their
		-- default behavior. For example, here we set the section for
		-- cursor location to LINE:COLUMN
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end

		-- ... and there is more!
		--  Check out: https://github.com/nvim-mini/mini.nvim
	end,
}
