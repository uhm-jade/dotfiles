-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Helper function for setting keymaps
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

local M = {}

-- lala!!
M.setup_general = function()
	--[[
		NORMAL MODE MAPPINGS
	--]]
	-- Join line while keeping the cursor in the same position
	map("n", "J", "mzJ`z")

	-- Toggle the code-fold under the cursor
	map("n", "Z", "zA")

	-- Use zh and zl to close and open folds
	map("n", "zh", "zc")
	map("n", "zl", "zo")

	-- Pressing s twice saves the file
	map("n", "ss", ":w<Cr>")

	-- Double tap [] to change buffers
	-- nevermind
	-- map("n", "[b", "[[")
	-- map("n", "]b", "]]")

	-- List all buffers
	map("n", "<leader>lb", ":ls<CR>:b<space>")

	--[[
		VISUAL MODE MAPPINGS
	--]]
	-- Move selected lines with shift+j or shift+k
	map("v", "J", ":m '>+1<CR>gv=gv")
	map("v", "K", ":m '<-2<CR>gv=gv")

	--[[
		INSERT MODE MAPPINGS
	--]]
	--	map('i', '"', '""<left>')
end

M.setup_general()

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil: Open parent directory" })

return M
