local opts = { noremap = true, silent = true }

M = {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
	keys = {
		{
			"<leader>f",
			"<cmd>lua require('weihang.plugins.telescope').project_files()<cr>",
			mode = "n",
			desc = "Telescope find files",
			opts,
		},
		{
			"<leader>t",
			"<cmd>lua require('weihang.plugins.telescope').project_grep()<cr>",
			mode = "n",
			desc = "Telescope live grep",
			opts,
		},
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

		local function filenameFirst(_, path)
			local tail = vim.fs.basename(path)
			local parent = vim.fs.dirname(path)
			if parent == "." then
				return tail
			end
			return string.format("%s\t\t%s", tail, parent)
		end

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				entry_prefix = "  ",
				path_display = filenameFirst,

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
					-- path_display = { "smart" },
				},
				git_files = {
					show_untracked = true,
				},
			},
			extensions = {},
		})
	end,
}

-- cache results of "git rev-parse"
local is_inside_work_tree = {}

-- git_files with find_files as fallback
M.project_files = function()
	local builtin = require("telescope.builtin")
	local f_opts = { previewer = false }
	local cwd = vim.fn.getcwd()
	if is_inside_work_tree[cwd] == nil then
		vim.fn.system("git rev-parse --is-inside-work-tree")
		is_inside_work_tree[cwd] = vim.v.shell_error == 0
	end

	if is_inside_work_tree[cwd] then
		builtin.git_files(f_opts)
	else
		builtin.find_files(f_opts)
	end
end

M.project_grep = function()
	local builtin = require("telescope.builtin")
	local function get_git_root()
		local dot_git_path = vim.fn.finddir(".git", ".;")
		return vim.fn.fnamemodify(dot_git_path, ":h")
	end
	local cwd = vim.fn.getcwd()
	local grep_opts = {}
	if is_inside_work_tree[cwd] == nil then
		vim.fn.system("git rev-parse --is-inside-work-tree")
		is_inside_work_tree[cwd] = vim.v.shell_error == 0
		opts = { cwd = get_git_root }
	end
	builtin.live_grep(grep_opts)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "TelescopeResults",
	callback = function(ctx)
		vim.api.nvim_buf_call(ctx.buf, function()
			vim.fn.matchadd("TelescopeParent", "\t\t.*$")
			vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
		end)
	end,
})

return M
