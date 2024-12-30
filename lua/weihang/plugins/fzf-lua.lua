local opts = { noremap = true, silent = true }

local M = {
	"ibhagwan/fzf-lua",
	dependencies = { "echasnovski/mini.icons" },
	keys = {
		{
			"<leader>f",
			"<cmd>lua require('weihang.plugins.fzf-lua').project_files()<cr>",
			mode = "n",
			desc = "fzf-lua find files",
			opts,
		},
		{
			"<leader>t",
			"<cmd>FzfLua live_grep<cr>",
			mode = "n",
			desc = "Telescope live grep",
			opts,
		},
		{
			"<leader>b",
			"<cmd>FzfLua buffers previewer=false<cr>",
			mode = "n",
			desc = "Telescope find buffers",
			opts,
		},
	},
	opts = {
		winopts = {
			preview = {
				layout = "vertical",
			},
		},
		keymap = {
			-- Below are the default binds, setting any value in these tables will override
			-- the defaults, to inherit from the defaults change [1] from `false` to `true`
			builtin = {
				-- neovim `:tmap` mappings for the fzf win
				-- true,        -- uncomment to inherit all the below in your custom config
				["<M-Esc>"] = "hide", -- hide fzf-lua, `:FzfLua resume` to continue
				["<F1>"] = "toggle-help",
				["<F2>"] = "toggle-fullscreen",
				-- Only valid with the 'builtin' previewer
				["<F3>"] = "toggle-preview-wrap",
				["<F4>"] = "toggle-preview",
				-- Rotate preview clockwise/counter-clockwise
				["<F5>"] = "toggle-preview-ccw",
				["<F6>"] = "toggle-preview-cw",
				-- `ts-ctx` binds require `nvim-treesitter-context`
				["<F7>"] = "toggle-preview-ts-ctx",
				["<F8>"] = "preview-ts-ctx-dec",
				["<F9>"] = "preview-ts-ctx-inc",
				["<S-Left>"] = "preview-reset",
				["<S-down>"] = "preview-page-down",
				["<S-up>"] = "preview-page-up",
				["<M-S-down>"] = "preview-down",
				["<M-S-up>"] = "preview-up",
			},
			fzf = {
				-- fzf '--bind=' options
				-- true,        -- uncomment to inherit all the below in your custom config
				["ctrl-z"] = "abort",
				["ctrl-u"] = "unix-line-discard",
				["ctrl-f"] = "half-page-down",
				["ctrl-b"] = "half-page-up",
				["ctrl-a"] = "beginning-of-line",
				["ctrl-e"] = "end-of-line",
				["alt-a"] = "toggle-all",
				["alt-g"] = "first",
				["alt-G"] = "last",
				-- Only valid with fzf previewers (bat/cat/git/etc)
				["f3"] = "toggle-preview-wrap",
				["f4"] = "toggle-preview",
				["shift-down"] = "preview-page-down",
				["shift-up"] = "preview-page-up",
			},
		},
		git = {
			files = {
				prompt = "Git Files❯ ",
				cmd = "git ls-files -c --others --exclude-standard",
				multiprocess = true, -- run command in a separate process
				git_icons = true, -- show git icons?
				file_icons = true, -- show file icons (true|"devicons"|"mini")?
				color_icons = true, -- colorize file|git icons
				-- force display the cwd header line regardless of your current working
				-- directory can also be used to hide the header when not wanted
				cwd_header = true,
			},
			icons = {
				["M"] = { icon = "", color = "yellow" },
				["D"] = { icon = "", color = "red" },
				["A"] = { icon = "A", color = "green" },
				["R"] = { icon = "R", color = "yellow" },
				["C"] = { icon = "C", color = "yellow" },
				["T"] = { icon = "T", color = "magenta" },
				["?"] = { icon = "?", color = "magenta" },
			},
		},
		grep = {
			prompt = "grep❯ ",
		},
	},
}

local is_inside_work_tree = {}

-- Project files with normal files as fallback
M.project_files = function()
	local fzf_lua = require("fzf-lua")
	local f_opts = { previewer = false }
	local cwd = vim.fn.getcwd()
	if is_inside_work_tree[cwd] == nil then
		vim.fn.system("git rev-parse --is-inside-work-tree")
		is_inside_work_tree[cwd] = vim.v.shell_error == 0
	end

	if is_inside_work_tree[cwd] then
		fzf_lua.git_files(f_opts)
	else
		fzf_lua.files(f_opts)
	end
end

return M
