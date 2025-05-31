return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			view = {
				width = 35,
			},
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
		},
	},
}
