return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- "ray-x/lsp_signature.nvim", -- function help
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
				"lua_ls",
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
				formatting.prettier.with({
					filetypes = {
						"javascript",
						"typescript",
						"css",
						"scss",
						"html",
						"json",
						"yaml",
						"markdown",
						"graphql",
						"md",
						"txt",
					},
				}),
				formatting.eslint_d,

				-- python
				formatting.black.with({ extra_args = { "--fast", "-l 79" } }),
				formatting.isort,
				diagnostics.flake8,

				-- lua
				formatting.stylua,

				-- java
				formatting.google_java_format,
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
	{
		"glepnir/lspsaga.nvim",
		enabled = true,
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		cmd = "Lspsaga",
		keys = { -- LSP finder - Find the symbol's definition
			-- If there is no definition, it will instead be hidden
			-- When you use an action in finder like "open vsplit",
			-- you can use <C-t> to jump back
			{ "gh", "<cmd>Lspsaga finder<CR>", mode = "n" },

			-- Code action
			{ "<leader>ca", "<cmd>Lspsaga code_action<CR>", mode = { "n", "v" } },

			-- Rename all occurrences of the hovered word for the selected files
			{ "<leader>rn", "<cmd>Lspsaga rename ++project<CR>", mode = "n" },

			-- Go to definition
			{ "gd", "<cmd>Lspsaga goto_definition<CR>", mode = "n" },

			-- Show line diagnostics
			-- You can pass argument ++unfocus to
			-- unfocus the show_line_diagnostics floating window
			{ "gl", "<cmd>Lspsaga show_line_diagnostics ++unfocus<CR>", mode = "n" },

			-- Show cursor diagnostics
			-- Like show_line_diagnostics, it supports passing the ++unfocus argument
			{ "gL", "<cmd>Lspsaga show_cursor_diagnostics ++unfocus<CR>", mode = "n" },
			{ "ga", "<cmd>Lspsaga show_buf_diagnostics<CR>", mode = "n" },
			{ "gA", "<cmd>Lspsaga show_workspace_diagnostics<CR>", mode = "n" },

			-- Diagnostic jump
			-- You can use <C-o> to jump back to your previous location
			{ "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", mode = "n" },
			{ "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", mode = "n" },

			-- Diagnostic jump with filters such as only jumping to an error
			{
				"[E",
				function()
					require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end,
				mode = "n",
			},
			{
				"]E",
				function()
					require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
				end,
				mode = "n",
			},

			-- Toggle outline
			{ "<leader>o", "<cmd>Lspsaga outline<CR>", mode = "n" },

			-- Hover Doc
			-- If there is no hover doc,
			-- there will be a notification stating that
			-- there is no information available.
			-- To disable it just use ":Lspsaga hover_doc ++quiet"
			-- Pressing the key twice will enter the hover window
			{ "K", "<cmd>Lspsaga hover_doc<CR>", mode = "n" },

			-- Call hierarchy
			{ "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", mode = "n" },
			{ "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", mode = "n" },
		},
		config = function()
			require("lspsaga").setup({
				symbol_in_winbar = {
					enable = false,
				},
				beacon = {
					enable = false,
				},
				lightbulb = {
					enable = false,
				},
				rename = {
					in_select = false,
					keys = {
						exec = "<CR>",
						select = "<Tab>",
					},
				},
				ui = {
					border = "rounded",
					expand = "",
					collapse = "",
					preview = " ",
					code_action = " ",
					diagnostic = " ",
					incoming = " ",
					outgoing = " ",
					hover = " ",
					kind = {},
				},
			})
		end,
	},

	{
		"mfussenegger/nvim-jdtls",
		keys = {
			{ "<leader>goi", "<cmd>lua require'jdtls'.organize_imports()<CR>", mode = "n", desc = "Organize imports" },
			{ "<leader>gev", "<cmd>lua require'jdtls'.extract_variable()<CR>", mode = "n", desc = "Organize imports" },
			{ "<leader>gec", "<cmd>lua require'jdtls'.extract_constant()<CR>", mode = "n", desc = "Organize imports" },
			{ "<leader>gem", "<cmd>lua require'jdtls'.extract_method()<CR>", mode = "n", desc = "Organize imports" },
			{ "<F4>", "<cmd>JdtCompile<CR>", mode = "n", desc = "Organize imports" },
		},
	},
}
