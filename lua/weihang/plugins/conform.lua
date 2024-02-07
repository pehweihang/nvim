return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>i",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "n",
			desc = "Format buffer",
		},
	},
	config = function()
    local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },

				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				svelte = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				jsonc = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },
				markdown = { { "prettierd", "prettier" } },
				graphql = { { "prettierd", "prettier" } },

				python = { "ruff_fix", "ruff_format" },

				go = { "goimports", "gofmt" },

				java = { "google-java-format" },

				["_"] = { "trim_whitespace" },
			},
			log_level = vim.log.levels.ERROR,
			notify_on_error = true,
		})

    conform.formatters.ruff_fix = {
      prepend_args = {"--select", "I"}
    }
	end,
}
