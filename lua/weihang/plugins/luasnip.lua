return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local status_ok, luasnip = pcall(require, "luasnip")
		if not status_ok then
			return
		end

		require("luasnip.loaders.from_vscode").load({
			paths = "~/.config/nvim/lua/weihang/cp-snippets/",
		})

		require("luasnip.loaders.from_vscode").lazy_load()
		luasnip.filetype_extend("typescript", { "javascript" })
	end,
}
