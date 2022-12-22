local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
	use("numToStr/Comment.nvim") -- Easily comment stuff
	use("kyazdani42/nvim-web-devicons") -- Glyphs and icons
	use("kyazdani42/nvim-tree.lua") -- File explorer
	use("akinsho/bufferline.nvim") -- bufferline
	use("moll/vim-bbye") -- better buffer closing
	use("nvim-lualine/lualine.nvim") -- statusline
	use("akinsho/toggleterm.nvim") -- terminal window
	use("mbbill/undotree") -- undo tree;
	use("ahmedkhalf/project.nvim")
	use("lewis6991/impatient.nvim")
	use("lukas-reineke/indent-blankline.nvim") -- add indent guides to blanklines
	use("goolord/alpha-nvim") -- startup page
	use("folke/trouble.nvim") -- diagnostics
	use("ellisonleao/glow.nvim") -- markdown viewer
	use("ggandor/lightspeed.nvim") -- navigation
	use("kylechui/nvim-surround")
	use("stevearc/dressing.nvim")

	-- session
	-- use("rmagatti/auto-session")
	-- use("rmagatti/session-lens")

	-- Colorschemes
	use("catppuccin/nvim")

	-- LSP
	use("neovim/nvim-lspconfig")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- Autocompletion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use("ray-x/lsp_signature.nvim") -- function help
	use("jose-elias-alvarez/null-ls.nvim")
	use("j-hui/fidget.nvim")

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("nvim-telescope/telescope-media-files.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "gbrlsnchs/telescope-lsp-handlers.nvim" })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Git
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-fugitive")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
