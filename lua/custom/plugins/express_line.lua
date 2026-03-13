return {
	"tjdevries/express_line.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("el.builtin")
		local extensions = require("el.extensions")
		local subscribe = require("el.subscribe")
		local sections = require("el.sections")

		require("el").setup({
			generator = function()
				local segments = {}

				table.insert(segments, extensions.mode)
				table.insert(segments, " ")
				table.insert(
					segments,
					subscribe.buf_autocmd("el_git_branch", "BufEnter", function(window, buffer)
						local branch = extensions.git_branch(window, buffer)
						if branch then
							return "  " .. branch
						end
					end)
				)
				table.insert(segments, " ")
				table.insert(segments, sections.split)
				table.insert(segments, "%f")
				table.insert(segments, sections.split)
				table.insert(segments, builtin.filetype)
				table.insert(segments, " ")
				table.insert(segments, builtin.line_with_width(3))
				table.insert(segments, ":")
				table.insert(segments, builtin.column_with_width(2))
				table.insert(segments, " ")

				return segments
			end,
		})
	end,
}
