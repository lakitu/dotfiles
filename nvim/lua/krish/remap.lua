vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")
vim.keymap.set("n", "<leader>t", function()
	vim.cmd('split')
	vim.cmd('wincmd j')
	vim.cmd('resize 10')
	vim.cmd('term')
	vim.cmd('startinsert')
end, {noremap = true, silent = true})

vim.keymap.set('n', 'U', function() vim.cmd('redo') end, {noremap=true})

vim.keymap.set('n', 'G', 'Gzz', {noremap=true, silent=true})

vim.keymap.set('n', "<C-s>", '<CMD>w<CR>', {noremap=true, silent=true})
vim.keymap.set('n', "<C-x>", '<CMD>q<CR>', {noremap=true, silent=true})

