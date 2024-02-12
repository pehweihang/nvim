return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		"BufReadPre "
			.. vim.fn.expand("~")
			.. "/Documents/obsidian/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/Documents/obsidian/**.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter",
	},
	config = function()
		require("obsidian").setup({
			workspaces = {
				{
					name = "personal",
					path = "~/Documents/obsidian/",
				},
			},
			note_id_func = function(title)
				return title
			end,
			note_frontmatter_func = function(note)
				local out = { tags = note.tags }

				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end

				return out
			end,
			completion = {
				nvim_cmp = true,

				-- Trigger completion at 2 chars.
				min_chars = 2,

				-- Where to put new notes created from completion. Valid options are
				--  * "current_dir" - put new notes in same directory as the current buffer.
				--  * "notes_subdir" - put new notes in the default notes subdirectory.
				new_notes_location = "notes_subdir",

				-- Either 'wiki' or 'markdown'.
				preferred_link_style = "markdown",

				-- Control how wiki links are completed with these (mutually exclusive) options:
				--
				-- 1. Whether to add the note ID during completion.
				-- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
				-- Mutually exclusive with 'prepend_note_path' and 'use_path_only'.
				prepend_note_id = false,
				-- 2. Whether to add the note path during completion.
				-- E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
				-- Mutually exclusive with 'prepend_note_id' and 'use_path_only'.
				prepend_note_path = true,
				-- 3. Whether to only use paths during completion.
				-- E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
				-- Mutually exclusive with 'prepend_note_id' and 'prepend_note_path'.
				use_path_only = false,
			},
			mappings = {
				-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				-- Toggle check-boxes.
				["<leader>ch"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
				["<leader>f"] = {
					action = function()
						vim.cmd("ObsidianQuickSwitch")
					end,
				},
			},
			ui = {
				enable = true, -- set to false to disable all additional syntax features
				update_debounce = 200, -- update delay after a text change (in milliseconds)
				-- Define how various check-boxes are displayed
				checkboxes = {
					-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { char = "", hl_group = "ObsidianDone" },
					[">"] = { char = "", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				},
				bullets = { char = "•", hl_group = "ObsidianBullet" },
				external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
				reference_text = { hl_group = "ObsidianRefText" },
				highlight_text = { hl_group = "ObsidianHighlightText" },
				tags = { hl_group = "ObsidianTag" },
				-- hl_groups = {
				-- 	-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
				-- 	ObsidianTodo = { bold = true, fg = "#f78c6c" },
				-- 	ObsidianDone = { bold = true, fg = "#89ddff" },
				-- 	ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				-- 	ObsidianTilde = { bold = true, fg = "#ff5370" },
				-- 	ObsidianBullet = { bold = true, fg = "#89ddff" },
				-- 	ObsidianRefText = { underline = true, fg = "#c792ea" },
				-- 	ObsidianExtLinkIcon = { fg = "#c792ea" },
				-- 	ObsidianTag = { italic = true, fg = "#89ddff" },
				-- 	ObsidianHighlightText = { bg = "#75662e" },
				-- },
			},
		})
	end,
}
