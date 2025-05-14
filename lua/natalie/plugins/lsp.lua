return {
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load for lua files
			},
			{
				"saghen/blink.cmp",
				version = "1.*",
				dependencies = {
					"L3MON4D3/LuaSnip",
				},
				opts = {
					signature = { enabled = true },
					sources = {
						-- add lazydev to your completion providers
						default = { "lazydev", "lsp", "path", "snippets", "buffer" },
						providers = {
							lazydev = {
								name = "LazyDev",
								module = "lazydev.integrations.blink",
								-- make lazydev completions top priority (see `:h blink.cmp`)
								score_offset = 100,
							},
						},
					},
				},
			},
		},
	},
}
