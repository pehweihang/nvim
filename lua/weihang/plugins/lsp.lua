local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"b0o/SchemaStore.nvim",
		"saghen/blink.cmp",
	},
}

M.toggle_inlay_hints = function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr }), { bufnr })
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
		vim.lsp.inlay_hint.enable(true, { bufnr })
		-- toggle inlay hints
		keymap(bufnr, "n", "<leader>lh", "<cmd>lua require('weihang.plugins.lsp').toggle_inlay_hints()<cr>", opts)
	end
end

local require_ok, blink_cmp = pcall(require, "blink.cmp")
if require_ok then
	M.capabilities = blink_cmp.get_lsp_capabilities()
end

M.config = function()
	require("mason").setup({
		ui = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
	})

	vim.diagnostic.config({
		virtual_text = {
			prefix = "● ",
			source = "if_many",
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "󰌵",
				[vim.diagnostic.severity.INFO] = "",
			},
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

	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"cssls",
			"html",
			"ts_ls",
			"pyright",
			"clangd",
			"bashls",
			"jsonls",
			"yamlls",
			"rust_analyzer",
		},
		automatic_enable = {
			exclude = { "rust_analyzer", "jdtls" },
		},
	})
end

return M
