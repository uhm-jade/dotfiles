return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = { -- <── Refers to LSP server name (for nvim-lspconfig)
					settings = {
						gopls = { -- <── Refers to gopls's server settings schema
							analyses = { unusedparams = true },
							staticcheck = true,
						},
					},
				},
			},
		},
	},
}
