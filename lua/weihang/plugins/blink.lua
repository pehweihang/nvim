local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		{ "saghen/blink.compat", lazy = true },
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "default" },
		completion = {
			menu = {
				border = border,
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind", "source_name", gap = 1 },
					},
				},
			},
			documentation = {
				window = {
					border = border,
				},
				auto_show = true,
				auto_show_delay_ms = 50,
			},
		},
		signature = {
			enabled = true,
			window = {
				border = border,
			},
		},
		cmdline = {
			keymap = { preset = "inherit" },
			completion = { menu = { auto_show = true } },
		},
		sources = {
			default = {
				"lazydev",
				"lsp",
				"path",
				"snippets",
				"buffer",
				"obsidian",
				"obsidian_new",
				"obsidian_tags",
			},
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				obsidian = {
					name = "obsidian",
					module = "blink.compat.source",
					score_offset = 100,
				},
				obsidian_new = {
					name = "obsidian_new",
					module = "blink.compat.source",
					score_offset = 100,
				},
				obsidian_tags = {
					name = "obsidian_tags",
					module = "blink.compat.source",
					score_offset = 100,
				},
				path = {
					opts = {
						show_hidden_files_by_default = true,
					},
				},
			},
		},
	},
}
