require("krish.remap")
local diagnostic = require("krish.diagnostic")

vim.o.background = "light"
vim.cmd [[colorscheme happy_hacking]]
-- vim.cmd [[colorscheme evergarden]]
-- vim.cmd [[colorscheme binary]]

vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*",
  callback = function()
    diagnostic.echo_diagnostic()
  end,
})

vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.colorcolumn = "80"
vim.opt.swapfile = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- 4 line vertical buffer around cursor at all times
vim.opt.scrolloff = 4

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- displays hybrid line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- search ignores case
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- sets tabs to spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 8
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 0

