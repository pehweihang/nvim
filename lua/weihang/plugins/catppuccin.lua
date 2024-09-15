return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "frappe",
			background = {
				light = "latte",
				dark = "frappe",
			},
			transparent_background = true,
			show_end_of_buffer = false,
			term_colors = false,
			dim_inactive = {
				enabled = true,
				shade = "dark",
				percentage = 0.1,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = {},
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = {},
			integrations = {
				fidget = true,
				gitsigns = true,
				harpoon = true,
				headlines = true,
				indent_blankline = {
					enabled = true,
					scope_color = "",
					colored_indent_levels = false,
				},
				markdown = true,
				mason = true,
				cmp = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
        neogit = true,
        render_markdown = true,
				semantic_tokens = true,
				treesitter_context = true,
				treesitter = true,
				telescope = {
					enabled = true,
					-- style = "nvchad"
				},
				lsp_trouble = false,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
