local servers = {
	"sumneko_lua",
	"cssls",
	"html",
	"tsserver",
	"pyright",
	"clangd",
	"bashls",
	"jsonls",
	"yamlls",
}

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
	return
end

mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

mason_lspconfig.setup_handlers({
	function(server)
		local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
		if not lspconfig_status_ok then
			return
		end

		local opts = {
			on_attach = require("weihang.lsp.handlers").on_attach,
			capabilities = require("weihang.lsp.handlers").capabilities,
		}

		local require_ok, conf_opts = pcall(require, "weihang.lsp.settings." .. server)
		if require_ok then
			opts = vim.tbl_deep_extend("force", conf_opts, opts)
		end

		lspconfig[server].setup(opts)
	end,

	["rust_analyzer"] = function()
		local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
		if not rust_tools_status_ok then
			return
		end

		local opts = {
			server = {
				on_attach = require("weihang.lsp.handlers").on_attach,
				capabilities = require("weihang.lsp.handlers").capabilities,
			},
		}

		local require_ok, conf_opts = pcall(require, "weihang.lsp.settings.rust_tools")
		if require_ok then
			opts = vim.tbl_deep_extend("force", conf_opts, opts)
		end

		rust_tools.setup(opts)
	end,
})

-- local opts = {}
--
-- for _, server in pairs(servers) do
-- 	opts = {
-- 		on_attach = require("weihang.lsp.handlers").on_attach,
-- 		capabilities = require("weihang.lsp.handlers").capabilities,
-- 	}
--
-- 	server = vim.split(server, "@")[1]
--
-- 	if server == "rust_analyzer" then
-- 		local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
-- 		if not rust_tools_status_ok then
-- 			return
-- 		end
--
-- 		local rust_opts = require("weihang.lsp.settings.rust")
--
-- 		rust_tools.setup(rust_opts)
-- 		goto continue
-- 	end
--
-- 	local require_ok, conf_opts = pcall(require, "weihang.lsp.settings." .. server)
-- 	if require_ok then
-- 		opts = vim.tbl_deep_extend("force", conf_opts, opts)
-- 	end
--
-- 	lspconfig[server].setup(opts)
-- 	::continue::
-- end
