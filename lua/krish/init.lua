require("krish.lazy")
require("krish.remap")
require("plugins.lsp-config")

vim.o.background = "light"
vim.cmd [[colorscheme happy_hacking]]
-- vim.cmd [[colorscheme rose-pine]]

vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.colorcolumn = "80"
vim.opt.swapfile = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- 4 line vertical buffer around cursor at all times
vim.opt.scrolloff = 4

-- displays hybrid line numbers
vim.wo.number = true
-- vim.wo.relativenumber = true

-- search ignores case
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- sets tabs to spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
