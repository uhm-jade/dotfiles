return {
	{
		"lopi-py/luau-lsp.nvim",
		opts = {
			platform = {
				type = "roblox",
			},
			types = {
				roblox_security_level = "PluginSecurity",
			},
			sourcemap = {
				enabled = true,
				autogenerate = true, -- automatic generation when the server is initialized
				rojo_project_file = "default.project.json",
				sourcemap_file = "sourcemap.json",
			},
			plugin = {
				enabled = true,
				port = 3667,
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function(_, opts)
			local function rojo_project()
				return vim.fs.root(0, function(name)
					return name:match(".+%.project%.json$")
				end)
			end

			if rojo_project() then
				opts.platform.type = "roblox"
				vim.filetype.add({
					extension = {
						lua = function(path)
							return path:match("%.nvim%.lua$") and "lua" or "luau"
						end,
					},
				})
			else
				opts.platform.type = "standard"
			end

			require("luau-lsp").setup(opts)
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			automatic_enable = {
				exclude = { "luau_lsp", "jsonls-lsp" },
			},
		},
	},
}
