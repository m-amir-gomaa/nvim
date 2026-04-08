return {
	-- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	opts = {
		-- delay between pressing a key and opening which-key (milliseconds)
		-- this setting is independent of vim.opt.timeoutlen
		delay = 0,
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-…> ",
				M = "<M-…> ",
				D = "<D-…> ",
				S = "<S-…> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
		},

		-- Document existing key chains
		spec = {
			{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>t", group = "[T]oggle / Trouble" },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			{ "<leader>q", group = "[Q]uickfix" },
			{ "<leader>n", group = "[N]otifications" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>i", group = "[I]mage" },
			{ "<leader>b", group = "[B]uffer" },
			{ "<leader>f", group = "[F]ormat" },
			{ "<leader>m", group = "[M]arkdown" },
			{ "<leader>mf", group = "[M]arkdown [F]old" },
			{ "<leader>mh", group = "[M]arkdown [H]eading" },
			{ "<leader>ml", group = "[M]arkdown [L]inks" },
			{ "<leader>ms", group = "[M]arkdown [S]pell" },
			{ "<leader>mt", group = "[M]arkdown [T]OC" },
			{ "[", group = "[[]Prev" },
			{ "]", group = "[]]Next" },
			{ "gs", group = "[G]lobal [S]urround" },
		},
	},
}
