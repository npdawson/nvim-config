return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
				cond = function ()
					return vim.fn.executable "cmake" == 1
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
		},
	},
}
