return {
	"catppuccin/nvim",
	config = function()
		vim.g.catppuccin_flavour = "frappe"

		local colors = require("catppuccin.palettes").get_palette()

		require("catppuccin").setup({
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			transparent_background = false,
			term_colors = false,
			compile = {
				enabled = false,
				path = vim.fn.stdpath("cache") .. "/catppuccin",
			},
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
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
			integrations = {
				aerial = false,
				barbar = false,
				beacon = false,
				cmp = true,
				coc_nvim = false,
				dashboard = false,
				fern = false,
				fidget = true,
				gitgutter = false,
				gitsigns = true,
				harpoon = false,
				hop = false,
				illuminate = false,
				leap = false,
				lightspeed = true,
				lsp_saga = false,
				lsp_trouble = true,
				markdown = true,
				mason = true,
				mini = false,
				neogit = false,
				neotest = false,
				neotree = false,
				noice = true,
				notify = true,
				nvimtree = true,
				overseer = false,
				pounce = false,
				semantic_tokens = false,
				symbols_outline = false,
				telekasten = false,
				telescope = true,
				treesitter = true,
				treesitter_context = false,
				ts_rainbow = false,
				vim_sneak = false,
				vimwiki = false,
				which_key = false,

				dap = {
					enabled = false,
					enable_ui = false,
				},
				indent_blankline = {
					enabled = true,
					colored_indent_levels = false,
				},
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
				},
				navic = {
					enabled = false,
					custom_bg = "NONE",
				},
			},
			highlight_overrides = { all = { FloatBorder = { bg = colors.mantle } } },
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
