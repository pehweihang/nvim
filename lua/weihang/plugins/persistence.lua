return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	keys = {
		{ "<leader>pl", '<cmd>lua require("persistence").load()<cr>', mode = "n" },
	},
	config = function()
		require("persistence").setup()
	end,
}
