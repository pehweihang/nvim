local opts = { noremap = true, silent = true }
return {
	"danymat/neogen",
	keys = { { "<leader>lgd", "<cmd>lua require('neogen').generate()<CR>", mode = "n", desc = "Run Neogen", opts } },
	config = function()
		require("neogen").setup({ enabled = true, input_after_comment = true, snippet_engine = "luasnip" })
	end,
}
