require("natalie.set")
require("natalie.remap")
require("natalie.lazy")

local augroup = vim.api.nvim_create_augroup
local NatalieGroup = augroup("Natalie", {})
local autocmd = vim.api.nvim_create_autocmd

-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

autocmd({ "BufWritePre" }, {
	group = NatalieGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]], -- remove trailing whitespace
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

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

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

local function telescope_live_grep_open_files()
	require("telescope.builtin").live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end
vim.keymap.set("n", "<leader>s/", telescope_live_grep_open_files, { desc = "[S]earch [/] in Open Files" })
vim.keymap.set("n", "<leader>ss", require("telescope.builtin").builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on Git Root" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })

-- [[ Configure LSP ]]
--	This function gets run when an LSP connects to a particular buffer.
-- local on_attach = function(_, bufnr)
-- 	-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- 	-- to define small helper and utility functions so you don't have to repeat yourself
-- 	-- many times.
-- 	--
-- 	-- In this case, we create a function that lets us more easily define mappings specific
-- 	-- for LSP related items. It sets the mode, buffer and description for us each time.
-- 	local nmap = function(keys, func, desc)
-- 		if desc then
-- 			desc = 'LSP: ' .. desc
-- 		end
--
-- 		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
-- 	end
--
-- 	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
-- 	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
--
-- 	nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
-- 	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
-- 	nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
-- 	nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
-- 	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
-- 	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
-- 	-- See `:help K` for why this keymap
-- 	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
-- 	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
--
-- 	-- Lesser used LSP functionality
-- 	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
-- 	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
-- 	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
-- 	nmap('<leader>wl', function()
-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 	end, '[W]orkspace [L]ist Folders')
--
-- 	-- Create a command `:Format` local to the LSP buffer
-- 	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
-- 		vim.lsp.buf.format()
-- 	end, { desc = 'Format current buffer with LSP' })
-- end

-- document existing key chains
require("which-key").add({
	{ "<leader>c", group = "[C]ode" },
	{ "<leader>d", group = "[D]ocument" },
	{ "<leader>g", group = "[G]it" },
	{ "<leader>h", group = "Git [H]unk" },
	{ "<leader>r", group = "[R]ename" },
	{ "<leader>s", group = "[S]earch" },
	{ "<leader>t", group = "[T]oggle" },
	{ "<leader>w", group = "[W]orkspace" },
})
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require("which-key").add({
	{ "<leader>", group = "VISUAL <leader>", mode = "v" },
	{ "<leader>h", desc = "Git [H]unk", mode = "v" },
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
-- require('mason').setup()
-- require('mason-lspconfig').setup()

-- LSP servers with configuration
local servers = {
	ols = {
		settings = {
			checker_args = "-vet -strict-style",
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
}

local ensure_installed = vim.tbl_keys(servers or {})
-- add other stuff with default settings
vim.list_extend(ensure_installed, {
	"gopls",
})

-- Ensure the lsp servers are installed
require("mason-lspconfig").setup({
	ensure_installed = ensure_installed,
	automatic_enable = true,
})

for server_name, config in pairs(servers) do
	vim.lsp.config(server_name, config)
end

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
-- local cmp = require 'cmp'
-- local luasnip = require 'luasnip'
-- require('luasnip.loaders.from_vscode').lazy_load()
-- luasnip.config.setup {}
--
-- cmp.setup {
-- 	snippet = {
-- 		expand = function(args)
-- 			luasnip.lsp_expand(args.body)
-- 		end,
-- 	},
-- 	completion = {
-- 		completeopt = 'menu,menuone,noinsert',
-- 	},
-- 	mapping = cmp.mapping.preset.insert {
-- 		['<C-n>'] = cmp.mapping.select_next_item(),
-- 		['<C-p>'] = cmp.mapping.select_prev_item(),
-- 		['<C-b>'] = cmp.mapping.scroll_docs(-4),
-- 		['<C-f>'] = cmp.mapping.scroll_docs(4),
-- 		['<C-y>'] = cmp.mapping.confirm({ select = true }),
-- 		['<C-Space>'] = cmp.mapping.complete {},
-- 	},
-- 	sources = {
-- 		{ name = 'nvim_lsp' },
-- 		{ name = 'luasnip' },
-- 		{ name = 'path' },
-- 	},
-- }

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
