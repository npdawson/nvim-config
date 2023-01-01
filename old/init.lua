require('configs')

-- If you want to automatically install and set up packer.nvim on any machine
-- you clone your configuration to, add the following snippet (which is due to
-- @Iron-E and @khuedoan) somewhere in your config before your first usage of
-- packer:

--local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1',
                                  'https://github.com/wbthomason/packer.nvim',
                                  install_path})
end

return require('packer').startup{function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { -- A collection of common configurations for Neovim's built-in language server client
        'neovim/nvim-lspconfig',
        config = [[ require('plugins/lspconfig') ]]
    }
    use {
        'williamboman/nvim-lsp-installer',
        config = [[ require('plugins/lsp_installer_nvim') ]]
    }
    use { -- vscode-like pictograms for neovim lsp completion items Topics
        'onsails/lspkind-nvim',
        config = [[ require('plugins/lspkind') ]]
    }
    use { -- Utility functions for getting diagnostic status and progress messages
          -- from LSP servers, for use in the Neovim statusline
        'nvim-lua/lsp-status.nvim',
        config = [[ require('plugins/lspstatus') ]]
    }
    use { -- A completion plugin for neovim coded in Lua.
        'hrsh7th/nvim-cmp',
        requires = {
          "hrsh7th/cmp-nvim-lsp",           -- nvim-cmp source for neovim builtin LSP client
          "hrsh7th/cmp-nvim-lua",           -- nvim-cmp source for nvim lua
          "hrsh7th/cmp-buffer",             -- nvim-cmp source for buffer words.
          "hrsh7th/cmp-path",               -- nvim-cmp source for filesystem paths.
          "hrsh7th/cmp-calc",               -- nvim-cmp source for math calculation.
          "saadparwaiz1/cmp_luasnip",       -- luasnip completion source for nvim-cmp
        },
        config = [[ require('plugins/cmp') ]],
    }
    use { -- Snippet Engine for Neovim written in Lua.
        'L3MON4D3/LuaSnip',
        requires = {
          "rafamadriz/friendly-snippets",   -- Snippets collection for a set of different
	                                    -- programming languages for faster development.
        },
        config = [[ require('plugins/luasnip') ]],
    }
    use {
	    'Mofiqul/dracula.nvim',
    }
    use { -- Nvim Treesitter configurations and abstraction layer
	    'nvim-treesitter/nvim-treesitter',
	    run = ':TSUpdate',
	    config = [[ require('plugins/treesitter') ]]
    }
    use { -- A super powerful autopairs plugin for Neovim. It supports multiple characters.
      'windwp/nvim-autopairs',
      config = [[ require('plugins/autopairs') ]]
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end, config = {
  -- Move to lua dir so impatient.nvim can cache it
  compile_path = vim.fn.stdpath('config')..'/plugin/packer_compiled.lua'
  }
}
