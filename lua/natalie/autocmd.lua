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

local hooks = function(ev)
	local name, kind = ev.data.spec.name, ev.data.kind

	if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
		vim.cmd('TSUpdate')
	end

	if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
		vim.system({ 'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release' }, { cwd = ev.data.path }, function(obj)
			if obj.code ~= 0 then
				vim.notify 'cmake --build failed for telescope-fzf-native.nvim'
			else
				vim.system({ 'cmake', '--build', 'build', '--config', 'Release', '--target', 'install' }, { cwd = ev.data.path })
			end
		end)
	end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

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
