require('Comment').setup({
	toggler = {
		line = '<C-/>',
		block = '<C-\\>',
	},
	opleader = {
		line = '<C-/>',
		block = '<C-\\>',
	}
})

-- Map <C-_> and <C-/> to toggle comments in normal mode
vim.keymap.set('n', '<C-_>', '<Plug>(comment_toggle_linewise_current)', { noremap = true, silent = true })
vim.keymap.set('n', '<C-/>', '<Plug>(comment_toggle_linewise_current)', { noremap = true, silent = true })

vim.keymap.set('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)', { noremap = true, silent = true })
vim.keymap.set('v', '<C-/>', '<Plug>(comment_toggle_linewise_visual)', { noremap = true, silent = true })
