vim.pack.add {
	-- colorschemes
	{ src = "https://github.com/catppuccin/nvim",       name = "catppuccin" },
	{ src = "https://github.com/folke/tokyonight.nvim", name = "tokyonight" },

	-- fancy features
	{ src = "https://github.com/windwp/nvim-autopairs" },

	-- highlight todo's and similar in comments
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	-- completion
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },

	-- LSP
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" }, -- useful status updates
	{ src = "https://github.com/neovim/nvim-lspconfig" },

	-- which key
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/folke/which-key.nvim" },

	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },

	-- git
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/tpope/vim-rhubarb" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	-- telescope
	'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim', -- Optional but recommended
}

local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup {
	completion = { documentation = { auto_show = true } },
}

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
			vim.keymap.set(mode, l, r, opts)
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
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
	end,
}

require('telescope').setup {}
require('telescope').load_extension('fzf')

require("mason").setup {}
require("mason-lspconfig").setup {}
require("fidget").setup {}
require("nvim-autopairs").setup {}
require("todo-comments").setup {}
require("ibl").setup {}
require("lualine").setup {}
