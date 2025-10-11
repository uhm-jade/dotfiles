return {
	"stevearc/oil.nvim",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	opts = {
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				return vim.startswith(name, ".DS_Store")
			end,
		},
		keymaps = {
			["<C-h>"] = false, -- Split
			["<C-l>"] = false, -- refresh
			["<leader>os"] = "actions.select_split",
			["<leader>ov"] = "actions.select_vsplit",
			["<C-g>"] = "actions.refresh",
		},
	},
}
