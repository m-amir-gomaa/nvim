-- add yours here
local map = vim.keymap.set

-- Basic & frequently used
-- NOTE: `;` is mapped to Telescope cmdline in telescope.lua — don't redefine here
map("i", "jk", "<Esc>", { desc = "Easy escape" })

-- yank/copy to end of line
map("n", "Y", "y$", { desc = "[P]Yank to end of line" })

-- Tab navigation
-- NOTE: avoid remapping bare `t` — it shadows the built-in t{char} motion
map("n", "gtn", ":tabnext<CR>", { silent = true, desc = "Next tab" })
map("n", "gtp", ":tabprev<CR>", { silent = true, desc = "Prev tab" })
map("n", "<leader>tn", ":tabnew<CR>", { silent = true, desc = "New tab" })

-- Buffer navigation
map("n", "bn", ":bn<CR>", { silent = true })
map("n", "bp", ":bp<CR>", { silent = true })
map("n", "b^", ":b#<CR>", { silent = true })
map("n", "bk", ":bd<CR>", { silent = true })

-- Resize windows with holding Alt + hjkl
map("n", "<M-k>", "<cmd>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<M-j>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<M-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<M-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Move lines up and down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "[P]Move line down in visual mode" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "[P]Move line up in visual mode" })

-- When you do joins with J it will keep your cursor at the beginning instead of at the end
map("n", "J", "mzJ`z")

-- When searching for stuff, search results show in the middle
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quickfix navigation
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Prev quickfix item" })
map("n", "<leader>qq", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- Marks keep coming back even after deleting them, this deletes them all
map("n", "<leader>mZ", function()
	vim.cmd("delmarks!")
	print("All marks deleted.")
end, { desc = "[P]Delete all marks" })

-- In visual mode, after going to the end of the line, come back 1 character
map("v", "gl", "$h", { desc = "[P]Go to the end of the line" })

-- Plugin toggles / utils
map("n", "<leader><leader>u", ":UndotreeToggle<CR>", { silent = true })

-- Rustacean keymaps — scoped to Rust buffers only via FileType autocmd
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function(ev)
		local opts = { silent = true, buffer = ev.buf }
		map("n", "K", function()
			vim.cmd.RustLsp({ "hover", "actions" })
		end, vim.tbl_extend("force", opts, { desc = "Rust hover actions" }))
		map("n", "<leader>ce", function()
			vim.cmd.RustLsp("explainError")
		end, vim.tbl_extend("force", opts, { desc = "Rust explain error" }))
		map("n", "<leader>cm", function()
			vim.cmd.RustLsp("expandMacro")
		end, vim.tbl_extend("force", opts, { desc = "Rust expand macro" }))
		map("n", "<leader>cc", function()
			vim.cmd.RustLsp("openCargo")
		end, vim.tbl_extend("force", opts, { desc = "Rust open Cargo.toml" }))
		map("n", "<leader>cj", function()
			vim.cmd.RustLsp({ "moveItem", "down" })
		end, vim.tbl_extend("force", opts, { desc = "Rust move item down" }))
		map("n", "<leader>ck", function()
			vim.cmd.RustLsp({ "moveItem", "up" })
		end, vim.tbl_extend("force", opts, { desc = "Rust move item up" }))
		map("n", "<Leader>dt", function()
			vim.cmd("RustLsp testables")
		end, vim.tbl_extend("force", opts, { desc = "Rust testables" }))
	end,
})

-- DAP keymaps live in custom/plugins/debug.lua (keys= table is the canonical source)
-- F1=step into, F2=step over, F3=step out, F5=continue/start, F7=toggle UI
-- <leader>b=toggle breakpoint, <leader>B=conditional breakpoint

map("n", "<leader>x", function()
	local line = vim.api.nvim_get_current_line()
	if line:match("%[ %]") then
		line = line:gsub("%[ %]", "[x]")
	elseif line:match("%[x%]") then
		line = line:gsub("%[x%]", "[ ]")
	else
		local indent = line:match("^(%s*)")
		line = indent .. "- [x] " .. line:gsub("^%s*", "")
	end
	vim.api.nvim_set_current_line(line)
end, { desc = "Toggle markdown task completion" })
