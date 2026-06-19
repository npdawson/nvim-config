--	NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set

keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

keymap("n", "<leader>f", vim.lsp.buf.format)

keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap("n", "<C-j>", "<cmd>cprev<CR>zz")
keymap("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap("n", "<leader>j", "<cmd>lprev<CR>zz")

-- greatest remap ever
keymap("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

keymap({ "n", "v" }, "<leader>d", [["_d]])

-- keymap("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap("n", "<leader>r", vim.lsp.buf.rename)
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })

-- TIP: Disable arrow keys in normal mode
-- keymap("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- keymap("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- keymap("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- keymap("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.get_prev, { desc = 'Go to previous diagnostic message' })
keymap('n', ']d', vim.diagnostic.get_next, { desc = 'Go to next diagnostic message' })
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
keymap({ "n", "x" }, "gca", vim.lsp.buf.code_action, { desc = "Go to code action" })

keymap("n", "<leader>z", ':lua require("FTerm").open()<CR>')
keymap("t", "<Esc>", '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>')

keymap("n", "<leader>t", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
