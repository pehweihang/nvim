local opts = { noremap = true, silent = true }

return {
	"NeogitOrg/neogit",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",

		"nvim-telescope/telescope.nvim",
	},
	keys = { { "<leader>gs", "<cmd>Neogit<cr>", mode = "n", desc = "Open Neogit", opts } },
	config = function()
		require("neogit").setup({})
	end,
}
