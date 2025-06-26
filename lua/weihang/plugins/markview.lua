return {
	"OXY2DEV/markview.nvim",
	enabled = false,
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.icons",
	},
	opts = {
		preview = {
			hybrid_modes = { "n" },
			filetypes = {
				"md",
				"markdown",
				"norg",
				"rmd",
				"org",
				"vimwiki",
				"typst",
				"latex",
				"quarto",
				"Avante",
				"codecompanion",
			},
		},
		latex = { enable = false },
	},
}
