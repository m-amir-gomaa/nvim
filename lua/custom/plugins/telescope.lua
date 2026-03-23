return {
	-- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jonarrien/telescope-cmdline.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		-- Two important keymaps to use while in Telescope are:
		--  - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		local telescope = require("telescope")
		local telescopeConfig = require("telescope.config")
		local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
		table.insert(vimgrep_arguments, "--hidden")
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")
		table.insert(vimgrep_arguments, "-L")
		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			-- defaults = {
			--   preview = { treesitter = false },
			-- },
			-- defaults = {
			--   mappings = {
			--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			--   },
			-- },
			defaults = {
				-- `hidden = true` is not supported in text grep commands.
				vimgrep_arguments = vimgrep_arguments,
			},
			pickers = {
				find_files = {
					theme = "ivy",
					-- find_command must be inside find_files, not at pickers level
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
			extensions = {
				fzf = {},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		require("telescope").load_extension("cmdline") -- Required!

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		-- Multi-grep: live grep with an optional file-glob filter separated by two spaces
		-- Usage: type your pattern, then two spaces, then a glob  e.g. "myFunc  *.lua"
		-- Inspired by TJ DeVries' Advent of Nvim Day 10
		local function multi_grep(opts)
			opts = opts or {}
			local finders = require("telescope.finders")
			local make_entry = require("telescope.make_entry")
			local pickers = require("telescope.pickers")
			local conf = require("telescope.config").values

			local live_grepper = finders.new_async_job({
				command_generator = function(prompt)
					if not prompt or prompt == "" then
						return nil
					end
					local pieces = vim.split(prompt, "  ")
					local args = { "rg" }
					if pieces[1] then
						table.insert(args, "-e")
						table.insert(args, pieces[1])
					end
					if pieces[2] then
						table.insert(args, "-g")
						table.insert(args, pieces[2])
					end
					return vim.iter({
						args,
						{
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
						},
					})
						:flatten()
						:totable()
				end,
				entry_maker = make_entry.gen_from_vimgrep(opts),
				cwd = opts.cwd,
			})

			pickers
				.new(opts, {
					debounce = 100,
					prompt_title = "Multi Grep  (pattern  [  glob])",
					finder = live_grepper,
					previewer = conf.grep_previewer(opts),
					sorter = require("telescope.sorters").empty(),
				})
				:find()
		end

		vim.keymap.set("n", "<leader>sM", multi_grep, { desc = "[S]earch [M]ulti-grep (pattern  glob)" })

		vim.keymap.set("n", ";", "<cmd>Telescope cmdline<cr>", { desc = "[C]mdline" })
		-- Fallback for the traditional command line in case Telescope crashes
		vim.keymap.set("n", "<leader>;", ":", { desc = "Traditional [;]cmdline" })
		-- vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
		-- vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')

		-- Multi-ripgrep: scope your grep by typing "pattern  glob" (two spaces = separator)
		-- Examples:
		--   "parseConfig"           → grep everywhere (same as live_grep)
		--   "parseConfig  *.go"     → grep only in Go files
		--   "TODO  src/**/*.ts"     → grep only in src/ TypeScript files
		--   "deprecated  !**/vendor/**"  → grep everywhere except vendor/
		--
		-- The sorter is intentionally empty — rg handles the ranking, not telescope.
		-- Results update with a 100ms debounce to avoid hammering rg on every keystroke.
		local function multi_grep(opts)
			opts = opts or {}
			opts.cwd = opts.cwd or vim.uv.cwd()

			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local make_entry = require("telescope.make_entry")
			local conf = require("telescope.config").values

			local finder = finders.new_async_job({
				command_generator = function(prompt)
					if not prompt or prompt == "" then
						return nil
					end

					local pieces = vim.split(prompt, "  ") -- TWO spaces are the separator
					local args = { "rg" }

					if pieces[1] then
						table.insert(args, "--regexp")
						table.insert(args, pieces[1])
					end

					if pieces[2] then
						table.insert(args, "--glob")
						table.insert(args, pieces[2])
					end

					return vim.iter({
						args,
						{
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
							"--hidden",
							"--glob",
							"!**/.git/*",
						},
					})
						:flatten()
						:totable()
				end,

				entry_maker = make_entry.gen_from_vimgrep(opts),
				cwd = opts.cwd,
			})

			pickers
				.new(opts, {
					debounce = 100,
					prompt_title = "Multi Grep  (pattern  [glob filter])",
					finder = finder,
					previewer = conf.grep_previewer(opts),
					sorter = require("telescope.sorters").empty(),
				})
				:find()
		end

		vim.keymap.set("n", "<leader>sM", multi_grep, { desc = "[S]earch [M]ulti-grep (pattern  glob)" })
	end,
}
