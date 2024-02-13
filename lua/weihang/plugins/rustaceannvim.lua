return {
	"mrcjkb/rustaceanvim",
	version = "^4",
	ft = { "rust" },
	config = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = require("weihang.plugins.lsp").on_attach,
			},
		}
	end,
}
