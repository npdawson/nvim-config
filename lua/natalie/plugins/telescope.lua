-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == "" then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ":h")
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not a git repository. Searching on current working directory")
		return cwd
	end
	return git_root
end

-- See `:help telescope.builtin`

local function telescope_live_grep_open_files()
	require("telescope.builtin").live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require("telescope.builtin").live_grep({
			search_dirs = { git_root },
		})
	end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
				cond = function()
					return vim.fn.executable "cmake" == 1
				end,
			},
			-- "nvim-telescope/telescope-ui-select.nvim",
		},
		keys = {
			{ "<leader>?",       require("telescope.builtin").oldfiles, desc = "[?] Find recently opened files" },
			{ "<leader><space>", require("telescope.builtin").buffers,  desc = "[ ] Find existing buffers" },
			{
				"<leader>/",
				function()
					-- You can pass additional configuration to telescope to change theme, layout, etc.
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
				desc = "[/] Fuzzily search in current buffer"
			},
			{ "<leader>s/", telescope_live_grep_open_files,           desc = "[S]earch [/] in Open Files" },
			{ "<leader>ss", require("telescope.builtin").builtin,     desc = "[S]earch [S]elect Telescope" },
			{ "<leader>gf", require("telescope.builtin").git_files,   desc = "Search [G]it [F]iles" },
			{ "<leader>sf", require("telescope.builtin").find_files,  desc = "[S]earch [F]iles" },
			{ "<leader>sh", require("telescope.builtin").help_tags,   desc = "[S]earch [H]elp" },
			{ "<leader>sw", require("telescope.builtin").grep_string, desc = "[S]earch current [W]ord" },
			{ "<leader>sg", require("telescope.builtin").live_grep,   desc = "[S]earch by [G]rep" },
			{ "<leader>sG", ":LiveGrepGitRoot<cr>",                   desc = "[S]earch by [G]rep on Git Root" },
			{ "<leader>sd", require("telescope.builtin").diagnostics, desc = "[S]earch [D]iagnostics" },
			{ "<leader>sr", require("telescope.builtin").resume,      desc = "[S]earch [R]esume" },
		},
	},
}
