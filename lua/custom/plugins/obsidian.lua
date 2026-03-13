-- obsidian.nvim — Obsidian integration for Neovim.
--
-- This plugin turns your markdown folder into a full Obsidian vault.
-- Features: Follow links, create notes, daily notes, templates, and more.
--
-- Documentation: https://github.com/epwalsh/obsidian.nvim

return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of main branch
	lazy = true,
	ft = "markdown",
	-- Only load when the vault exists; prevents startup crash on fresh machines
	cond = function()
		return vim.fn.isdirectory(vim.fn.expand("~/Notes")) == 1
	end,
	-- Replace the 'dependencies' and 'opts' with your own setup
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		-- Optional, for completion
		"saghen/blink.cmp",
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/Notes",
			},
		},

		-- Alternatively, optionally, keep notes in a specific directory in your vault.
		notes_subdir = "01-Notes",

		-- Optional, set the log level of obsidian.nvim. This is an integer corresponding to vim.log.levels.*
		log_level = vim.log.levels.INFO,

		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "04-Journal/Daily",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y-%m-%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%B %-d, %Y",
			-- Optional, if you want to automatically insert a template from your config area when creating a daily note.
			template = "daily.md",
		},

		-- Optional, completion of [[links]], [links], and #tags.
		completion = {
			-- Set to false to disable completion.
			nvim_cmp = false, -- Using blink.cmp instead
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},

		-- Optional, configure key mappings. These are the defaults, but Feel free to customize.
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes.
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			-- Smart action it depends on the context.
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},

		-- Optional, customize how names/IDs for new notes are created.
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note for the title 'My new note' will be given an ID that looks
			-- like '1657296016-my-new-note', and has the title 'My new note'.
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^%w%s-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,

		-- Optional, customize how note file names are generated given the ID and title.
		---@param spec { id: string, title: string|? }
		---@return string
		note_path_func = function(spec)
			local path = spec.dir / tostring(spec.id)
			return (path:with_suffix(".md")):to_string()
		end,

		-- Optional, configure templates.
		templates = {
			folder = "06-Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable name (e.g. 'foo')
			-- and the value should be a function that returns a string.
			substitutions = {},
		},

		-- Optional, set the frontmatter text that will be inserted when a new note is created.
		---@return table
		note_frontmatter_func = function(note)
			-- Add the title of the note as an alias.
			if note.title then
				note:add_alias(note.title)
			end

			local out = { id = note.id, aliases = note.aliases, tags = note.tags }

			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those are kept in the frontmatter as well.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,

		-- Optional, control how wiki links are generated.
		---@param opts { path: string, label: string, id: string|? }
		---@return string
		wiki_link_func = function(opts)
			if opts.id == nil then
				return string.format("[[%s]]", opts.label)
			else
				return string.format("[[%s|%s]]", opts.id, opts.label)
			end
		end,

		-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
		-- URL it will be ignored but you can customize this behavior here.
		---@param url string
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			vim.fn.jobstart({ "open", url }) -- macOS
			-- vim.fn.jobstart({"xdg-open", url}) -- linux
		end,

		-- Optional, set use_advanced_uri to true to use obsidian://advanced-uri URLs
		-- for jumping to notes.
		use_advanced_uri = false,

		-- Optional, set to true to force ':ObsidianOpen' to use the current Neovim window
		-- instead of splitting or opening a new tab.
		open_app_foreground = false,

		-- Optional, by default commands like `:ObsidianSearch` will attempt to use
		-- telescope.nvim, fzf-lua, or fzf.nvim (in that order), and fall back to
		-- search with ag or rg.
		picker = {
			-- If you want to use telescope.nvim
			name = "telescope.nvim",
			-- Optional, configure key mappings for the picker. These are the defaults.
			-- Not all pickers support all mappings.
			mappings = {
				-- Create a new note from your query.
				new = "<C-x>",
				-- Insert a link to the selected note.
				insert_link = "<C-l>",
			},
		},

		sort_by = "modified",
		sort_reversed = true,

		-- Optional, determines the UI style of the obsidian.nvim.
		ui = {
			enable = true, -- set to false to disable all UI features
			update_debounce = 200, -- update delay after a text change (in milliseconds)
			-- Define how various elements are rendered.
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "󰭻", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			-- Reference material: https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#ui-configuration
			reference_text = { hl_group = "ObsidianRefText" },
			highlight_text = { hl_group = "ObsidianHighlightText" },
			tags = { hl_group = "ObsidianTag" },
			hl_groups = {
				-- The GUI color of the highlight groups.
				ObsidianTodo = { bold = true, fg = "#f78c6c" },
				ObsidianDone = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				ObsidianTilde = { bold = true, fg = "#ff5370" },
				ObsidianBullet = { bold = true, fg = "#89ddff" },
				ObsidianRefText = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon = { fg = "#c792ea" },
				ObsidianTag = { italic = true, fg = "#485e30" },
				ObsidianHighlightText = { bg = "#75662e" },
			},
		},

		-- Specify how characters are handled when creating a new note title.
		attachments = {
			-- The default folder to place images in via `:ObsidianPasteImg`.
			img_folder = "assets/imgs", -- Default
			-- A function that determines the name of the image file.
			---@return string
			img_name_func = function()
				-- Prefix image name with timestamp.
				return string.format("%s-", os.time())
			end,
		},
	},
}
