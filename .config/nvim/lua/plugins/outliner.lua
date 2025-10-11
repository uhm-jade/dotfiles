return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	opts = {
		show_symbol_lineno = true,
		symbols = {
			filter = { "String", "Constant", exclude = true },
		},
	},
}
