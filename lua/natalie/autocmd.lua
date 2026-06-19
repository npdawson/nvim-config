local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- See `:help vim.hl.on_yank()`
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

autocmd({ "BufWritePre" }, {
	desc = "Remove trailing whitespace before saving buffer",
	group = augroup("RemoveTrailingWhitespace", {}),
	pattern = "*",
	command = [[%s/\s\+$//e]], -- remove trailing whitespace
})

-- autocmd("BufEnter", {
-- 	desc = "close nvim-tree if it's the last buffer open",
-- 	group = augroup("CloseNvimTree", {}),
-- 	pattern = "*",
-- 	callback = function()
-- 		if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "NvimTree" then
-- 			vim.cmd("NvimTreeToggle")
-- 			vim.cmd("quit")
-- 		end
-- 	end
-- })
