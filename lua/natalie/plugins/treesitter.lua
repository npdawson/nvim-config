return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter",
		opts = {
			-- No longer available in 0.12
			-- Add languages to be installed here that you want installed for treesitter
			-- ensure_installed = {
			-- 	"c",
			-- 	"cpp",
			-- 	"go",
			-- 	"lua",
			-- 	"python",
			-- 	"rust",
			-- 	"odin",
			-- 	"javascript",
			-- 	"typescript",
			-- 	"vimdoc",
			-- 	"vim",
			-- 	"bash",
			-- },

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
			auto_install = true,

			ignore_install = {},

			-- 0.12 update, remove the following
			-- highlight = { enable = true },
			-- indent = { enable = true },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = "<c-s>",
					node_decremental = "<M-space>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		init = function ()
			vim.api.nvim_create_autocmd('FileType', {
				callback = function ()
					-- Enable treesitter highlighting and disable regex syntax
					pcall(vim.treesitter.start)
					-- Enable treesitter-based indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			})

			local ensureInstalled = {
				'lua', 'python', 'typescript', 'odin', 'c', 'cpp',
			}
			local alreadyInstalled = require('nvim-treesitter.config').get_installed()
			local parsersToInstall = vim.iter(ensureInstalled)
				:filter(function (parser)
					return not vim.tbl_contains(alreadyInstalled, parser)
				end)
				:totable()
			require('nvim-treesitter').install(parsersToInstall)
		end,
	},
}
