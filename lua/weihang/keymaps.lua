local opts = { noremap = true, silent = true }

--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Resize with arrows
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)


-- Do not overwrite clipboard when pasting on selection
vim.keymap.set("x", "p", '"_dP', opts)

vim.keymap.set("s", "<BS>", "<C-o>s", opts)
