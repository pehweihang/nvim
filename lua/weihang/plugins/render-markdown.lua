return {
	"MeanderingProgrammer/render-markdown.nvim",
	enabled = true,
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
	opts = {
		file_types = {
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
}
