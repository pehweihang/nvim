return {
	"echasnovski/mini.animate",
	config = function()
		local animate = require("mini.animate")
		animate.setup({
			-- Cursor path
			cursor = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
			},

			-- Vertical scroll
			scroll = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
			},

			-- Window resize
			resize = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
			},

			open = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
			},

			close = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
			},
		})
	end,
}
