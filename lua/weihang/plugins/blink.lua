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
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"obsidian",
				"obsidian_new",
				"obsidian_tags",
			},
			providers = {
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
			},
		},
	},
}
