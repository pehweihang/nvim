local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

telescope.load_extension("media_files")

local actions = require("telescope.actions")

telescope.setup({
	defaults = {

		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },

		mappings = {
			i = {
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,

				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist, -- + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist, -- + actions.open_qflist,
				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
			},

			n = {
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["?"] = actions.which_key,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
		},
		-- Default configuration for builtin pickers goes here:
		-- picker_name = {
		--   picker_config_key = value,
		--   ...
		-- }
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
	},
	extensions = {
		media_files = {
			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg" },
			find_cmd = "rg", -- find command (defaults to `fd`)
		},
		-- Your extension configuration goes here:
		-- extension_name = {
		--   extension_config_key = value,
		-- }
		-- please take a look at the readme of the extension you want to configure
	},
})

telescope.load_extension("fzf")
telescope.load_extension("lsp_handlers")

-- neoclip
-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap(
	"n",
	"<leader>f",
	"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
	opts
)
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>Telescope live_grep<cr>", opts)
vim.api.nvim_set_keymap(
	"n",
	"<leader>b",
	"<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
	opts
)
vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>D", "<cmd>Telescope diagnostics<CR>", opts)
vim.api.nvim_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
vim.api.nvim_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
vim.api.nvim_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
