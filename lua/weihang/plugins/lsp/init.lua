return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"ray-x/lsp_signature.nvim", -- function help
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("weihang.plugins.lsp.handlers").setup()
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					border = "none",
					icons = {
						package_installed = "◍",
						package_pending = "◍",
						package_uninstalled = "◍",
					},
				},
				log_level = vim.log.levels.INFO,
				max_concurrent_installers = 4,
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"simrat39/rust-tools.nvim",
		},
		opts = {
			ensure_installed = {
				"sumneko_lua",
				"cssls",
				"html",
				"tsserver",
				"pyright",
				"clangd",
				"bashls",
				"jsonls",
				"yamlls",
			},
			automatic_installation = true,
		},
		config = function(plugin, opts)
			require("mason-lspconfig").setup(opts)
			require("mason-lspconfig").setup_handlers({
				function(server)
					local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
					if not lspconfig_status_ok then
						return
					end

					local opts = {
						on_attach = require("weihang.plugins.lsp.handlers").on_attach,
						capabilities = require("weihang.plugins.lsp.handlers").capabilities,
					}

					local require_ok, conf_opts = pcall(require, "weihang.plugins.lsp.settings." .. server)
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
							on_attach = require("weihang.plugins.lsp.handlers").on_attach,
							capabilities = require("weihang.plugins.lsp.handlers").capabilities,
						},
					}

					local require_ok, conf_opts = pcall(require, "weihang.plugins.lsp.settings.rust_tools")
					if require_ok then
						opts = vim.tbl_deep_extend("force", conf_opts, opts)
					end

					rust_tools.setup(opts)
				end,
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls_status_ok, null_ls = pcall(require, "null-ls")
			if not null_ls_status_ok then
				return
			end

			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
			local formatting = null_ls.builtins.formatting
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
			local diagnostics = null_ls.builtins.diagnostics

			local sources = {
				-- ts/js
				formatting.prettier,
				formatting.eslint_d,

				-- python
				formatting.black.with({ extra_args = { "--fast", "-l 79" } }),
				formatting.isort,
				diagnostics.flake8,

				-- lua
				formatting.stylua,
			}

			-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				debug = false,
				sources = sources,
				-- format on save
				-- on_attach = function(client, bufnr)
				-- 	if client.supports_method("textDocument/formatting") then
				-- 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				-- 		vim.api.nvim_create_autocmd("BufWritePre", {
				-- 			group = augroup,
				-- 			buffer = bufnr,
				-- 			callback = function()
				-- 				vim.lsp.buf.format({ bufnr = bufnr })
				-- 			end,
				-- 		})
				-- 	end
				-- end,
			})
		end,
	},
}
