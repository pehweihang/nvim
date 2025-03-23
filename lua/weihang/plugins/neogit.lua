local opts = { noremap = true, silent = true }

return {
	"pehweihang/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	keys = { { "<leader>g", "<cmd>Neogit<cr>", mode = "n", desc = "Open Neogit", opts } },
	config = function()
		require("neogit").setup({
			disable_hint = true,
			graph_style = "kitty",
			integrations = {
				fzf_lua = true,
				diffview = true,
			},
		})
	end,
}
