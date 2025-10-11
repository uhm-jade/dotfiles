return {
	{
		"nvimdev/lspsaga.nvim",
		after = "nvim-lspconfig",
		opt = {},
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					enable = false,
				},
				code_action_icon = "x",
			})
			local map = vim.keymap.set
			map("n", "<leader>rn", ":Lspsaga rename<cr>", { desc = "Lspsaga Rename" })
			map("n", "<leader>ca", ":Lspsaga code_action<cr>", { desc = "Lspsaga Code action" })
			map("n", "<leader>cd", ":Lspsaga peek_definition<cr>", { desc = "Peek definition" })
			map("n", "<leader>c/", ":Lspsaga finder<cr>", { desc = "Find all references" })
			map("n", "<S-k>", ":Lspsaga hover_doc<cr>", { desc = "Hover doc" })

			map("n", "gd", ":Lspsaga goto_definition<cr>", { desc = "Go to definition" })
			--map("n", "<leader>co", ":Lspsaga outline<cr>", { desc = "Outline" })
			map("n", "gl", ":Lspsaga show_line_diagnostics<cr>", { desc = "Show line diagnostics" })
		end,
	},
}
