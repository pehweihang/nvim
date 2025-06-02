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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end
		local opts = { noremap = true, silent = true, buffer = ev.buf }
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover({ border = \"rounded\" })<CR>", opts)
		vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help({ border = \"rounded\" })<CR>", opts)
		vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
		vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
			-- toggle inlay hints
			vim.keymap.set("n", "<leader>lh", "<cmd>lua require('weihang.plugins.lsp').toggle_inlay_hints()<cr>", opts)
		end
	end,
})

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
			style = "minimal",
			border = "rounded",
			source = true,
			header = "",
			prefix = "",
		},
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
