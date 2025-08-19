return {
	"obsidian-nvim/obsidian.nvim",
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
		---@module 'obsidian'
		---@type obsidian.config
		require("obsidian").setup({
			-- A list of workspace names, paths, and configuration overrides.
			-- If you use the Obsidian app, the 'path' of a workspace should generally be
			-- your vault root (where the `.obsidian` folder is located).
			-- When obsidian.nvim is loaded by your plugin manager, it will automatically set
			-- the workspace to the first workspace in the list whose `path` is a parent of the
			-- current markdown file being edited.
			workspaces = {
				{
					name = "personal",
					path = "~/Documents/obsidian",
				},
			},

			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "Dailies",
				-- Optional, if you want to change the date format for the ID of daily notes.
				date_format = "%Y-%m-%d",
				-- Optional, if you want to change the date format of the default alias of daily notes.
				alias_format = "%B %-d, %Y",
				-- Optional, default tags to add to each new daily note created.
				default_tags = { "daily-notes" },
				-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
				template = nil,
				workdays_only = false,
			},

			-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
			completion = {
				-- Set to false to disable completion.
				nvim_cmp = true,
				-- Trigger completion at 2 chars.
				min_chars = 2,
			},

			-- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
			-- way then set 'mappings = {}'.
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
				-- Smart action depending on context, either follow link or toggle checkbox.
				["<cr>"] = {
					action = function()
						return require("obsidian").util.smart_action()
					end,
					opts = { buffer = true, expr = true },
				},
			},

			-- Where to put new notes. Valid options are
			--  * "current_dir" - put new notes in same directory as the current buffer.
			--  * "notes_subdir" - put new notes in the default notes subdirectory.
			new_notes_location = "notes_subdir",

			-- Optional, customize how note IDs are generated given an optional title.
			---@param title string|?
			---@return string
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.date("%Y%m%d%H%M%S")) .. "-" .. suffix
			end,

			-- Either 'wiki' or 'markdown'.
			preferred_link_style = "wiki",

			-- Optional, boolean or a function that takes a filename and returns a boolean.
			-- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
			disable_frontmatter = false,

			-- Optional, for templates (see below).
			templates = {
				folder = "Templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				-- A map for custom variables, the key should be the variable and the value a function
				substitutions = {},
			},

			---@param url string
			follow_url_func = function(url)
				vim.fn.jobstart({ "xdg-open", url }) -- linux
			end,

			---@param img string
			follow_img_func = function(img)
				vim.fn.jobstart({ "xdg-open", img }) -- linux
			end,

			picker = {
				-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
				name = "telescope.nvim",
				-- Optional, configure key mappings for the picker. These are the defaults.
				-- Not all pickers support all mappings.
				note_mappings = {
					-- Create a new note from your query.
					new = "<C-x>",
					-- Insert a link to the selected note.
					insert_link = "<C-l>",
				},
				tag_mappings = {
					-- Add tag(s) to current note.
					tag_note = "<C-x>",
					-- Insert a tag at the current location.
					insert_tag = "<C-l>",
				},
			},

			-- Optional, sort search results by "path", "modified", "accessed", or "created".
			-- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
			-- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
			sort_by = "modified",
			sort_reversed = true,

			-- Set the maximum number of lines to read from notes on disk when performing certain searches.
			search_max_lines = 1000,

			-- Optional, determines how certain commands open notes. The valid options are:
			-- 1. "current" (the default) - to always open in the current window
			-- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
			-- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
			open_notes_in = "current",

			-- Optional, configure additional syntax highlighting / extmarks.
			-- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
			ui = {
				enable = false, -- set to false to disable all additional syntax features
			},

			-- Specify how to handle attachments.
			attachments = {
				-- The default folder to place images in via `:ObsidianPasteImg`.
				-- If this is a relative path it will be interpreted as relative to the vault root.
				-- You can always override this per image by passing a full path to the command instead of just a filename.
				img_folder = "Files", -- This is the default
			},
		})
	end,
}
