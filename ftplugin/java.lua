local config = {
  cmd = { "jdtls" },
  root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
}

vim.api.nvim_buf_create_user_command(0, "Format", "lua vim.lsp.buf.format()", {})

require("jdtls").start_or_attach(config)
