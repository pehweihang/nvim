return {
	"moll/vim-bbye",
	keys = {
		{ "<leader>z", "<cmd>Bdelete<CR>", mode = "n", { silent = true } },
		{ "<leader>Z", "<cmd>bufdo Bdelete<CR>", mode = "n", { silent = true } },
	},
}
