return {
	{ "mfussenegger/nvim-dap" },
	{
		"lommix/godot.nvim",
		lazy = true,
		cmd = { "GodotDebug", "GodotBreakAtCursor", "GodotStep", "GodotQuit", "GodotContinue" },
		config = function()
			local godot = require("godot")
			local config = {
				bin = "godot",
				dap = {
					host = "127.0.0.1",
					port = 6006,
				},
				gui = {
					console_config = {
						anchor = "SW",
						border = "double",
						col = 1,
						height = 10,
						relative = "editor",
						row = 99999,
						style = "minimal",
						width = 99999,
					},
				},
				expose_commands = true,
			}
			godot.setup(config)
		end,
		keys = {
			{ "<leader>dd", ":GodotDebug<CR>" },
		}
	}
}
