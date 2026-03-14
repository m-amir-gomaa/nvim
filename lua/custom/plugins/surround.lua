return {
	-- tpope's classic vim-surround plugin
	"tpope/vim-surround",
	event = "VeryLazy",
	dependencies = {
		-- vim-surround depends on vim-repeat for the dot (.) command to work properly
		"tpope/vim-repeat",
	},
}

