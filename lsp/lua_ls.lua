return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = {
					"?.lua",
					"?/init.lua",
				},
			},
			workspace = {
				library = {
          vim.env.VIMRUNTIME,

					vim.fn.expand("~/dev/koreader/frontend/"),
				},
			},
		},
	},
}
