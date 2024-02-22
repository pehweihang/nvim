local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"b0o/SchemaStore.nvim",
	},
}

M.toggle_inlay_hints = function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
end

M.on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(bufnr, true)
		-- toggle inlay hints
		keymap(bufnr, "n", "<leader>lh", "<cmd>lua require('weihang.plugins.lsp').toggle_inlay_hints()<cr>", opts)
	end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
local require_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if require_ok then
	M.capabilities = vim.tbl_deep_extend("force", M.capabilities, cmp_nvim_lsp.default_capabilities())
end

M.config = function()
	require("mason").setup({
		ui = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
	})

	require("mason-lspconfig").setup({
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
			"rust_analyzer",
		},
	})

	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "󰌵" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	vim.diagnostic.config({
		virtual_text = {
			prefix = "● ",
			source = "if_many",
		},
		signs = {
			active = signs,
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local servers_settings = {
		lua_ls = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				hint = { enable = true },
			},
		},
		jsonls = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
		yamlls = {
			yaml = {
				schemas = require("schemastore").yaml.schemas(),
				schemaStore = { enable = false, url = "" },
			},
		},
	}

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = M.capabilities,
				on_attach = M.on_attach,
				settings = servers_settings[server_name],
			})
		end,
		["rust_analyzer"] = {},
	})
end

return M
