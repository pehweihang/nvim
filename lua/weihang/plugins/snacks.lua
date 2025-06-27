local opts = { noremap = true, silent = true }

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>Go",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Open repo of the active file in the browser",
			opts,
		},
		{
			"<leader>f",
			function()
				git_files()
			end,
			desc = "Find git files",
			opts,
		},
		{
			"<leader>F",
			function()
				Snacks.picker.files({
					hidden = true,
					layout = { hidden = { "preview" } },
				})
			end,
			desc = "Find files",
			opts,
		},
		{
			"<leader>t",
			function()
				git_grep()
			end,
			desc = "Grep git files",
			opts,
		},
		{
			"<leader>T",
			function()
				Snacks.picker.grep({
					hidden = true,
				})
			end,
			desc = "Find files",
			opts,
		},
	},
	config = function()
		---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
		local progress = vim.defaulttable()
		vim.api.nvim_create_autocmd("LspProgress", {
			---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
				if not client or type(value) ~= "table" then
					return
				end
				local p = progress[client.id]

				for i = 1, #p + 1 do
					if i == #p + 1 or p[i].token == ev.data.params.token then
						p[i] = {
							token = ev.data.params.token,
							msg = ("[%3d%%] %s%s"):format(
								value.kind == "end" and 100 or value.percentage or 100,
								value.title or "",
								value.message and (" **%s**"):format(value.message) or ""
							),
							done = value.kind == "end",
						}
						break
					end
				end

				local msg = {} ---@type string[]
				progress[client.id] = vim.tbl_filter(function(v)
					return table.insert(msg, v.msg) or not v.done
				end, p)

				local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
				vim.notify(table.concat(msg, "\n"), "info", {
					id = "lsp_progress",
					title = client.name,
					opts = function(notif)
						notif.icon = #progress[client.id] == 0 and " "
							or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
					end,
				})
			end,
		})

		require("snacks").setup({
			animate = { enabled = true },
			bigfile = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true, top_down = false, margin = { bottom = 3 } },
			scroll = { enabled = true },
			indent = { enabled = true, chunk = { enabled = true } },
			image = {
				enabled = true,
				img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments", "Files" },
			},
			gitbrowse = { enabled = true },
			picker = {
				enabled = true,
				ui_select = true,
				formatters = {
					file = {
						filename_first = true,
					},
				},
				win = {
					-- input window
					input = {
						keys = {
							["<Esc>"] = "cancel",
							["/"] = "toggle_focus",
							["<C-c>"] = { "cancel", mode = "i" },
							["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
							["<CR>"] = { "confirm", mode = { "n", "i" } },
							["<c-y>"] = { "confirm", mode = { "n", "i" } },
							["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
							["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
							["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
							["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
							["<c-a>"] = { "select_all", mode = { "n", "i" } },
							["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
							["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
							["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
							["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
							["<c-n>"] = { "list_down", mode = { "i", "n" } },
							["<c-p>"] = { "list_up", mode = { "i", "n" } },
							["<c-q>"] = { "qflist", mode = { "i", "n" } },
							["<c-s>"] = { "edit_split", mode = { "i", "n" } },
							["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
							["?"] = "toggle_help_input",
							["G"] = "list_bottom",
							["gg"] = "list_top",
							["j"] = "list_down",
							["k"] = "list_up",
							["q"] = "close",
						},
						b = {
							minipairs_disable = true,
						},
					},
					list = {
						keys = {
							["/"] = "toggle_focus",
							["<2-LeftMouse>"] = "confirm",
							["<CR>"] = "confirm",
							["<c-y>"] = { "confirm" },
							["<Esc>"] = "cancel",
							["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
							["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
							["<a-p>"] = "toggle_preview",
							["<a-w>"] = "cycle_win",
							["<c-a>"] = "select_all",
							["<c-f>"] = "preview_scroll_down",
							["<c-b>"] = "preview_scroll_up",
							["<c-d>"] = "list_scroll_down",
							["<c-u>"] = "list_scroll_up",
							["<c-n>"] = "list_down",
							["<c-p>"] = "list_up",
							["<c-q>"] = "qflist",
							["<c-s>"] = "edit_split",
							["<c-t>"] = "tab",
							["<c-v>"] = "edit_vsplit",
							["?"] = "toggle_help_list",
							["G"] = "list_bottom",
							["gg"] = "list_top",
							["i"] = "focus_input",
							["j"] = "list_down",
							["k"] = "list_up",
							["q"] = "close",
							["zb"] = "list_scroll_bottom",
							["zt"] = "list_scroll_top",
							["zz"] = "list_scroll_center",
						},
					},
				},
			},
		})
	end,
}
