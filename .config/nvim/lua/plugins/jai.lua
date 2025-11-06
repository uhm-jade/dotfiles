return {
	{
		"rluba/jai.vim",
		config = function() end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				jai = {
					cmd = { "jai" },
					root_dir = function()
						return vim.fn.getcwd()
					end,
				},
			},
		},
	},
	-- EXTRA CRUD --
	-- Colored ANSI output in buffers
	-- (see keymaps.lua for usage of this in build keymap <leader>B)
	{
		"m00qek/baleia.nvim",
		version = "*",
		config = function()
			vim.g.baleia = require("baleia").setup({})

			-- Command to colorize the current buffer
			vim.api.nvim_create_user_command("BaleiaColorize", function()
				vim.g.baleia.once(vim.api.nvim_get_current_buf())
			end, { bang = true })
		end,
	},
}
