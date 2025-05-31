function ColorMyPencils(color)
	color = color or "catppuccin" --"tokyonight-moon"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true
		},
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			transparent_background = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end
	},
}
