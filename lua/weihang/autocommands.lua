-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("EasyQuit", {}),
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir", "fugitive" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
	end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = vim.api.nvim_create_augroup("HighlightYank", {}),
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- Competitive programming autocmds
local CPGroup = vim.api.nvim_create_augroup("CP", {})
-- Cpp complie and run keymaps
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = CPGroup,
	pattern = { "cpp" },
	callback = function()
		vim.opt.mp = "g++ -O2 -Wall --std=c++17 -Wno-unused-result %:r.cpp -o %:r"
		vim.keymap.set("n", "<F2>", "<cmd>vs %:r.in<CR>")
		vim.keymap.set("n", "<F3>", "<cmd>!time ./%:r < %:r.in <CR>")
		vim.keymap.set("n", "<F4>", "<cmd>w<CR><cmd>make<CR>")
		vim.keymap.set("n", "<F5>", "<cmd>w<CR><cmd>make<CR><cmd>!time ./%:r < %:r.in<CR>")
	end,
})

-- Python complie and run keymaps
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = CPGroup,
	pattern = { "python" },
	callback = function()
		vim.keymap.set("n", "<F5>", "<cmd>w<CR><cmd>!time python ./%:r.py < %:r.in<CR>")
	end,
})
