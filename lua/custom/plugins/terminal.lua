-- Floating terminal — no external plugin needed.
-- Uses Neovim's built-in terminal + floating window API.
--
-- The terminal buffer persists across toggles: closing the window does not
-- kill the shell. Re-opening it resumes exactly where you left off.
-- A new buffer is only created when none exists yet, or after the process exits.
--
-- Keymaps:
--   <leader>tt   (normal or terminal mode) — toggle the floating window
--   <Esc><Esc>   (terminal mode)           — exit terminal mode (back to normal)
--                                            already set in init.lua

return {
	{
		-- 'virtual = true' tells lazy.nvim this is a config-only spec with no plugin to download.
		dir = vim.fn.stdpath("config"),
		name = "floating-terminal",
		virtual = true,
		config = function()
			local term_buf = nil
			local term_win = nil

			local function toggle_float_term()
				-- If the window is open and valid → hide it
				if term_win and vim.api.nvim_win_is_valid(term_win) then
					vim.api.nvim_win_hide(term_win)
					term_win = nil
					return
				end

				-- Compute dimensions: 85% wide, 80% tall, centred
				local width = math.floor(vim.o.columns * 0.85)
				local height = math.floor(vim.o.lines * 0.80)
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)

				-- Reuse existing buffer if still valid; otherwise create fresh
				if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
					term_buf = vim.api.nvim_create_buf(false, true)
				end

				term_win = vim.api.nvim_open_win(term_buf, true, {
					relative = "editor",
					width = width,
					height = height,
					row = row,
					col = col,
					style = "minimal",
					border = "rounded",
					title = "  Terminal  ",
					title_pos = "center",
				})

				-- Only start the shell the very first time; subsequent opens reuse the session
				if vim.bo[term_buf].buftype ~= "terminal" then
					vim.cmd("terminal")
				end

				vim.cmd("startinsert")
			end

			-- Works from both normal mode and while already inside the terminal
			vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_float_term, {
				desc = "[T]oggle floating [T]erminal",
			})
		end,
	},
}
