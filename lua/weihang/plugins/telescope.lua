local opts = { noremap = true, silent = true }

return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
	keys = {
		{
			"<leader>f",
			"<cmd>Telescope find_files previewer=false<cr>",
			mode = "n",
			desc = "Telescope find files",
			opts,
		},
		{ "<leader>t", "<cmd>Telescope live_grep<cr>", mode = "n", desc = "Telescope live grep", opts },
		{
			"<leader>b",
			"<cmd>Telescope buffers previewer=false<cr>",
			mode = "n",
			desc = "Telescope find buffers",
			opts,
		},
	},
	config = function()
		local telescope = require("telescope")

		telescope.load_extension("fzf")

		local actions = require("telescope.actions")
		local layout_actions = require("telescope.actions.layout")

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "smart" },

				layout_strategy = "vertical",
				layout_config = {
					prompt_position = "top",
					mirror = true,
				},
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<C-p>"] = layout_actions.toggle_preview,

						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,

						["<C-c>"] = actions.close,

						["<CR>"] = function()
							vim.cmd([[:stopinsert]])
							vim.cmd([[call feedkeys("\<CR>")]])
						end,
						-- ["<CR>"] = actions.select_default,

						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
					},

					n = {
						["<esc>"] = actions.close,
						["<C-p>"] = layout_actions.toggle_preview,

						["<CR>"] = actions.select_default,

						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,

						["gg"] = actions.move_to_top,
						["G"] = actions.move_to_bottom,

						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
				},
				live_grep = {
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
			},
			extensions = {},
		})
	end,
}
