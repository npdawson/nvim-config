-- ==Options==
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.incsearch = true

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.cursorline = true

vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.wrap = false

vim.opt.undofile = true
vim.opt.swapfile = false

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@") -- add the @ character to filename detection

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.cmd [[set completeopt+=menuone,noselect,popup]]

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

vim.opt.colorcolumn = "80"

-- vim.opt.fileencodings = "utf-8,cp932,sjis,default"

vim.opt.winborder = "rounded"
vim.opt.winblend = 15

--	NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ==Main Keymap==
local keymap = vim.keymap.set

keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

keymap("v", "J", "<cmd>m '>+1<CR>gv=gv")
keymap("v", "K", "<cmd>m '<-2<CR>gv=gv")

keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

keymap("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Buffer" })

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

keymap("n", "<leader>o", "<cmd>up<CR><cmd>so<CR>", { desc = "Update and Source Buffer" })
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "[W]rite Buffer" })

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
keymap('n', '<leader>l', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
-- keymap({ "n", "x" }, "gca", vim.lsp.buf.code_action, { desc = "Go to code action" })

-- ==Autocmds==
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

-- tell omni complete about LSP
autocmd('LspAttach', {
	group = augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
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

autocmd('PackChanged', { callback = hooks })

-- ==Plugins==
vim.pack.add {
	-- colorschemes
	{ src = "https://github.com/catppuccin/nvim",       name = "catppuccin" },
	-- { src = "https://github.com/folke/tokyonight.nvim", name = "tokyonight" },

	-- fancy features
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
	{ src = "https://github.com/nvim-mini/mini.pick" },

	-- file explorer
	{ src = "https://github.com/stevearc/oil.nvim" },

	-- highlight todo's and similar in comments
	{ src = "https://github.com/folke/todo-comments.nvim" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	-- completion
	-- { src = "https://github.com/rafamadriz/friendly-snippets" },
	-- { src = "https://github.com/saghen/blink.lib" },
	-- { src = "https://github.com/saghen/blink.cmp" },

	-- LSP
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" }, -- useful status updates
	{ src = "https://github.com/neovim/nvim-lspconfig" },

	-- which key
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/folke/which-key.nvim" },

	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },

	-- git
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/tpope/vim-rhubarb" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	-- telescope
	-- 'https://github.com/nvim-lua/plenary.nvim',
	-- 'https://github.com/nvim-telescope/telescope.nvim',
	-- 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', -- Optional but recommended
}

require('mini.surround').setup {}
require('mini.pick').setup {}

keymap('n', '<leader>sf', "<cmd>Pick files<CR>")
keymap('n', '<leader>sb', "<cmd>Pick buffers<CR>")
keymap('n', '<leader>sh', "<cmd>Pick help<CR>")
keymap('n', '<leader>sg', "<cmd>Pick grep_live<CR>")
keymap('n', '<leader>sr', "<cmd>Pick resume<CR>")

require('oil').setup {}
keymap('n', '<leader>e', "<cmd>Oil<CR>")

-- local cmp = require("blink.cmp")
-- cmp.build():pwait()
-- cmp.setup {
-- 	completion = { documentation = { auto_show = true } },
-- }

require('gitsigns').setup {
	-- See `:help gitsigns.txt`
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			keymap(mode, l, r, opts)
		end

		-- Navigation
		map({ "n", "v" }, "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Jump to next hunk" })

		map({ "n", "v" }, "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Jump to previous hunk" })

		-- Actions
		-- visual mode
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "stage git hunk" })
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "reset git hunk" })
		-- normal mode
		map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
		map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
		map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
		map("n", "<leader>hR", gs.reset_buffer, { desc = "git Reset buffer" })
		map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
		map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })
		map("n", "<leader>hb", function()
			gs.blame_line({ full = false })
		end, { desc = "git blame line" })
		map("n", "<leader>hd", gs.diffthis, { desc = "git diff against index" })
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end, { desc = "git diff against last commit" })

		-- Toggles
		map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
		map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

		-- Text object
		map({ "o", "x" }, "ih", "<cmd><C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
	end,
}

-- require('telescope').setup {}
-- require('telescope').load_extension('fzf')

require("mason").setup {}
require("mason-lspconfig").setup {}
require("fidget").setup {}
require("nvim-autopairs").setup {}
-- require("todo-comments").setup {}
require("ibl").setup {}
require("lualine").setup {}

---@type vim.lsp.Config
local config = {
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        preloadFileSize = 10000,
        library = {
          vim.env.VIMRUNTIME,
        }
      },
    },
  },
}

vim.lsp.config('lua_ls', config)

-- document existing key chains
require("which-key").add({
	-- { "<leader>c", group = "[C]ode" },
	-- { "<leader>d", group = "[D]ocument" },
	{ "<leader>g", group = "[G]it" },
	{ "<leader>h", group = "Git [H]unk" },
	{ "<leader>r", group = "[R]ename" },
	{ "<leader>s", group = "[S]earch" },
	{ "<leader>t", group = "[T]oggle" },
	-- { "<leader>w", group = "[W]orkspace" },
})
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require("which-key").add({
	{ "<leader>", group = "VISUAL <leader>", mode = "v" },
	{ "<leader>h", desc = "Git [H]unk", mode = "v" },
})

function ColorMyPencils(color)
	color = color or "catppuccin" --"tokyonight-moon"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end

ColorMyPencils "catppuccin"
