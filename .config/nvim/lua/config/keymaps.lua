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

-- Function to run the build in a reusable terminal
local build_term = {}
local function run_build()
	-- save current file

	if vim.bo.modified then
		vim.cmd("write")
	end

	local file = vim.fn.expand("%:p")
	if file == "" then
		print("No file to build")
		return
	end

	-- check if terminal buffer still exists
	if not build_term.buf or not vim.api.nvim_buf_is_valid(build_term.buf) then
		vim.cmd("botright vsplit")
		vim.cmd("vertical resize 80") -- optional width
		vim.cmd("terminal")
		build_term.win = vim.api.nvim_get_current_win()
		build_term.buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(build_term.buf, "BuildTerminal")
	elseif not vim.api.nvim_win_is_valid(build_term.win) then
		-- reopen window if closed
		vim.cmd("botright vsplit")

		vim.api.nvim_win_set_buf(0, build_term.buf)

		build_term.win = vim.api.nvim_get_current_win()
	end

	-- switch to terminal window and clear it
	vim.api.nvim_set_current_win(build_term.win)
	vim.fn.chansend(vim.b.terminal_job_id, "clear\n")

	-- run the build command

	vim.fn.chansend(vim.b.terminal_job_id, "./build.sh " .. file .. "\n")

	-- return to previous window (so it doesn’t steal focus)
	vim.cmd("wincmd p")
end

local function is_buffer_open(buffer_name_or_id)
	-- bufwinnr returns the window number if the buffer is in a window,
	-- and -1 otherwise.
	local win_num = vim.fn.bufwinnr(buffer_name_or_id)
	return win_num ~= -1, win_num
end

local M = {}

M.setup_general = function()
	--[[
		NORMAL MODE MAPPINGS
	--]]
	-- Poor woman's Jai "go to definition"
	vim.keymap.set("n", "<leader>*", function()
		local word = vim.fn.expand("<cword>")
		local pattern = "\\<" .. word .. "\\>\\s*:"

		vim.fn.setreg("/", pattern)
		vim.fn.feedkeys("?" .. pattern .. "\n", "n")
	end, { noremap = true, silent = true })

	-- BUILD SCRIPT
	--map("n", "<leader>B", ":w<CR>:vertical terminal ./build.sh %<CR>")
	map("n", "<leader>B", function()
		vim.cmd("write")

		local is_open, win_num = is_buffer_open("BuildTerminal")
		if is_open then
			local win_id = vim.fn.win_getid(win_num)
			local buf_id = vim.api.nvim_win_get_buf(win_id)
			vim.api.nvim_set_current_win(win_id)
			vim.api.nvim_command("bdelete")
			--vim.api.nvim_command("close")
			--vim.api.nvim_buf_delete(buf_id, { force = false })
			--vim.api.nvim_win_close(win_id, false)
		end
		vim.cmd("vertical terminal ./build.sh " .. vim.fn.expand("%:p"))

		local new_buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(new_buf, "BuildTerminal")
	end)

	-- ; to :
	map("n", ";", ":")
	map("n", ":", ";")

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

	-- Better buffer navigation
	vim.keymap.del("n", "<leader>bp")
	map("n", "<leader>bn", ":bn<CR>")
	map("n", "<leader>bp", ":bp<CR>")

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
