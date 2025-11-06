local function theme(id, opts)
	return {
		id,
		lazy = false,
		priority = 1000,
		opts = opts,
	}
end

return {
	theme("rebelot/kanagawa.nvim"),
	theme("maxmx03/solarized.nvim"),
	theme("rose-pine/neovim", {
		commentStyle = { italic = false },
		keywordStyle = { italic = false },
		overrides = function()
			return {
				["@variable.builtin"] = { italic = false },
			}
		end,
	}),
	theme("webhooked/kanso.nvim", {
		theme = "zen",
	}),

	-- configure lazyvim to load theme
	{
		"LazyVim/LazyVim",
		opts = {
			--colorscheme = "kanagawa",
			--colorscheme = "solarized",
			-- colorscheme = "rose-pine",
			--colorscheme = "catppuccin",
			colorscheme = "kanso",
		},
	},
}
