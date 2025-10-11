return {
	-- add themes
	{ "rebelot/kanagawa.nvim" },
	{ "maxmx03/solarized.nvim" },
	{ "rose-pine/neovim" },

	-- configure lazyvim to load theme
	{
		"LazyVim/LazyVim",
		opts = {
			--colorscheme = "kanagawa",
			--colorscheme = "solarized",
			colorscheme = "rose-pine",
			--colorscheme = "catppuccin",
		},
	},
}
