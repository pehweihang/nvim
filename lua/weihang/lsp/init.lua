local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("weihang.lsp.mason")
require("weihang.lsp.handlers").setup()
require("weihang.lsp.null-ls")
