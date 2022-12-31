local opts = { noremap = true, silent = true }

--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>Bdelete<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>Z", "<cmd>bufdo Bdelete<CR>", { silent = true })

-- Cursor stays in middle when navigating
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzz")
-- vim.keymap.set("n", "N", "Nzz")

-- Resize with arrows
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
vim.keymap.set("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move text up and down
vim.keymap.set("v", "J", "<cmd>m .+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", "<cmd>m .-2<CR>gv=gv", opts)
vim.keymap.set("v", "p", '"_dP', opts)
