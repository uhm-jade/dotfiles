return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		keymap = { preset = "super-tab" },
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 1000,
			},
			ghost_text = {
				enabled = false,
				-- Show the ghost text when an item has been selected
				show_with_selection = true,
				-- Show the ghost text when no item has been selected, defaulting to the first item
				show_without_selection = false,
				-- Show the ghost text when the menu is open
				show_with_menu = true,
				-- Show the ghost text when the menu is closed
				show_without_menu = true,
			},
		},
	},
}
