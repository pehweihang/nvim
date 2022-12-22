local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
	return
end

require("luasnip/loaders/from_vscode").load({
	paths = "~/.config/nvim/after/cp-snippets/",
})

require("luasnip/loaders/from_vscode").lazy_load()
luasnip.filetype_extend("typescript", { "javascript" })
