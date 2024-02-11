return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({

			ensure_installed = {
				"vimdoc",
				"javascript",
				"typescript",
				"python",
				"c",
				"cpp",
				"lua",
				"rust",
				"jsdoc",
				"bash",
			},
			sync_install = false,
			ignore_install = { "" }, -- List of parsers to ignore installing
			auto_install = true,
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = { "" }, -- list of language that will be disabled
				additional_vim_regex_highlighting = true,
			},
		})
	end,
}
