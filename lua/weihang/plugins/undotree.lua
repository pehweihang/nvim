return {
  "mbbill/undotree",
	keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", mode = "n", desc = "UndoTree" } },
  config = function ()
    vim.g.undotree_WindowLayout = 1
    vim.g.undotree_SetFocusWhenToggle = 1
  end
}
