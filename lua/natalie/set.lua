vim.opt.guicursor = ""

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.incsearch = true

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.cursorline = true

-- vim.opt.mouse = 'a'

vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.wrap = false

vim.opt.undofile = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@") -- add the @ character to filename detection

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

vim.opt.colorcolumn = "80"

vim.opt.fileencodings = "utf-8,cp932,sjis,default"
