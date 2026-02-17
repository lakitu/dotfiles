local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>pc', builtin.colorscheme, { desc = 'Telescope colorscheme' })
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>pg', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

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

