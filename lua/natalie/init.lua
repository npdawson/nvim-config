require("natalie.autocmd")
require("natalie.keymaps")
require("natalie.options")

require("natalie.lazy")

pcall(require("telescope").load_extension, "fzf")
-- pcall(require("telescope").load_extension, "ui-select")


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
					library = vim.env.VIMRUNTIME
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
	clangd = {
		init_options = {
			fallbackFlags = { '--std=gnu23' }
		},
	},
}

-- separate config for zig/zls nightly
vim.lsp.config("zls", {
	settings = {
		zls = {
			enable_build_on_save = true,
			semantic_tokens = "partial",
		},
	},
})

vim.lsp.enable("zls")
vim.lsp.enable("gdscript")

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
