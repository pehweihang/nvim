return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local mode = {
				"mode",
				fmt = function(str)
					return "-- " .. str .. " --"
				end,
			}
			local filetype = {
				"filetype",
				icons_enabled = true,
				icon = { align = "left" },
			}

			local spaces = function()
				return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
			end

			local branch = {
				"branch",
				icons_enabled = true,
				icon = "",
			}

			local diff = {
				"diff",
				colored = false,
				symbols = { added = " ", modified = " ", removed = " " },
			}

			local diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn", "info" },
				symbols = { error = " ", warn = " ", info = " " },
				colored = false,
				update_in_insert = false,
				always_visible = true,
			}
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { mode },
					lualine_b = { branch, diff },
					lualine_c = { "filename" },
					lualine_x = { diagnostics },
					lualine_y = { filetype, spaces, "encoding" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}
