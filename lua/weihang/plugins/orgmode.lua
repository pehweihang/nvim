return {
	"nvim-orgmode/orgmode",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		{
			"akinsho/org-bullets.nvim",
			config = function()
				require("org-bullets").setup()
			end,
		},
	},
	config = function()
		-- Load custom treesitter grammar for org filetype
		require("orgmode").setup_ts_grammar()

		require("orgmode").setup({
			org_agenda_files = { "~/Documents/org/**/*" },
			org_default_notes_file = "~/Documents/org/refile.org",
			org_ellipsis = " ",
		})

		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = vim.api.nvim_create_augroup("Org", {}),
			pattern = { "org" },
			callback = function()
				vim.opt.conceallevel = 2
				vim.opt.concealcursor = "nc"
			end,
		})
	end,
}
