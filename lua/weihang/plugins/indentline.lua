return {
  "lukas-reineke/indent-blankline.nvim", -- add indent guides to blanklines
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    local status_ok, indent_blankline = pcall(require, "ibl")
    if not status_ok then
      return
    end
    indent_blankline.setup({
      exclude = {
        filetypes = {
          "help",
          "alpha",
        },
      },
    })
  end,
}
