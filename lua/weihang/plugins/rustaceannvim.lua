return {
	"mrcjkb/rustaceanvim",
	version = "^4",
	ft = { "rust" },
	config = function()
		vim.g.rustaceanvim = {
			server = {
				capabilities = require("weihang.plugins.lsp").capabilities,
			},
		}
	end,
}
