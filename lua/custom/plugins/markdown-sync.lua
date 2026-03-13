-- markdown-sync.lua — Automated Git syncing for your notes vault.
--
-- This script sets up an autocommand that automatically commits and pushes
-- changes to your markdown notes whenever you save them.
--
-- Best used with SSH keys to avoid password prompts.

local vault_path = vim.fn.expand("~/Notes")

-- Simple function to run git commands in the vault
local function sync_notes()
	-- Check if we are inside the vault
	local current_file = vim.api.nvim_buf_get_name(0)
	if not current_file:match("^" .. vault_path) then
		return
	end

	vim.notify("Syncing notes...", vim.log.levels.INFO)

	-- Run git commands in the background
	vim.fn.jobstart(
		{
			"/bin/sh",
			"-c",
			"cd "
				.. vault_path
				.. ' && git add . && git commit -m "Auto-save: '
				.. os.date("%Y-%m-%d %H:%M:%S")
				.. '" && git push',
		},
		{
			on_exit = function(_, exit_code)
				if exit_code == 0 then
					vim.notify("Notes synced successfully!", vim.log.levels.INFO)
				else
					vim.notify("Notes sync failed. Check your git status manually.", vim.log.levels.ERROR)
				end
			end,
		}
	)
end

-- Create autocommand group
local sync_group = vim.api.nvim_create_augroup("MarkdownSync", { clear = true })

-- Trigger on BufWritePost (after saving a file)
vim.api.nvim_create_autocmd("BufWritePost", {
	group = sync_group,
	pattern = "*.md",
	callback = sync_notes,
})

return {
	-- This is a 'virtual' plugin spec to ensure the autocommands are loaded.
	dir = vim.fn.stdpath("config"),
	name = "markdown-sync",
	virtual = true,
	config = function()
		-- The logic is already defined above, but we could place it here if needed.
	end,
}
