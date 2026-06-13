local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>pc', builtin.colorscheme, { desc = 'Telescope colorscheme' })
-- vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pg', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader>pw', function()
        require('telescope').extensions.git_worktree.git_worktrees()
end)
vim.keymap.set('n', '<leader>pb', builtin.git_branches, { desc = 'Telescope git branches' })

-- allows scrolling in telescope popup
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = require('telescope.actions').move_selection_next,  -- Move down in insert mode
        ["<C-k>"] = require('telescope.actions').move_selection_previous,  -- Move up in insert mode
      },
      n = {
        ["j"] = require('telescope.actions').move_selection_next,  -- Move down in normal mode
        ["k"] = require('telescope.actions').move_selection_previous,  -- Move up in normal mode
      }
    }
  },

  pickers = {
      colorscheme = {
          enable_preview = true
      },
      find_files = {
              hidden = true,
      },
  },
}

-- connect telescope to git-worktree.nvim
require('telescope').load_extension('git_worktree')

