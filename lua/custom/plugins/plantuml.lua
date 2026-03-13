return {
	-- PlantUML Syntax Highlighting
	{
		"aklt/plantuml-syntax",
		ft = "plantuml",
	},

	-- Open browser for viewing
	{
		"tyru/open-browser.vim",
		keys = {
			{ "<leader>op", "<Plug>(openbrowser-smart-search)", desc = "Open Browser" },
		},
	},

	-- The dedicated previewer
	{
		"weirongxu/plantuml-previewer.vim",
		ft = "plantuml",
		dependencies = { "tyru/open-browser.vim", "aklt/plantuml-syntax" },
		config = function()
			-- Keybindings for PlantUML
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "plantuml",
				callback = function()
					vim.keymap.set(
						"n",
						"<leader>dv",
						":PlantumlOpen<CR>",
						{ buffer = true, desc = "[U]ML [V]iew (Open Browser)" }
					)
					vim.keymap.set(
						"n",
						"<leader>ds",
						":PlantumlSave<CR>",
						{ buffer = true, desc = "[U]ML [S]ave (as image)" }
					)
				end,
			})
		end,
	},
}
