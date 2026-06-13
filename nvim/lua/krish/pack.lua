local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
        -- critical plugins
        { src=gh('nvim-lua/plenary.nvim') },
        { src=gh('nvim-telescope/telescope.nvim') },
        { src=gh('stevearc/oil.nvim') },
        { src=gh('nvim-treesitter/nvim-treesitter'), branch='main' },

        -- themes
        { src=gh('catppuccin/nvim') },
        { src=gh('yorickpeterse/happy_hacking.vim'), name='happy-hacking' },
        { src=gh('comfysage/evergarden') },
        { src=gh('jackplus-xyz/binary.nvim'), name="binary" },
        { src=gh('projekt0n/github-nvim-theme'), name="github" },
        { src=gh('ellisonleao/gruvbox.nvim'), name="gruvbox" },

        { src=gh('nvim-tree/nvim-web-devicons') },
        { src=gh('nvim-lualine/lualine.nvim') },

        -- lsp
        { src=gh('williamboman/mason.nvim') },
        { src=gh('mason-org/mason-lspconfig.nvim') },
	{ src=gh('saghen/blink.lib'), },
        { src=gh('saghen/blink.cmp') },
        { src=gh('rafamadriz/friendly-snippets') },
        { src=gh('neovim/nvim-lspconfig') },

        -- { src=gh('nvim-flutter/flutter-tools.nvim') },

        -- convenience
        { src=gh('theprimeagen/harpoon') },
        { src=gh('lakitu/git-worktree.nvim') },
        { src=gh('folke/trouble.nvim') },
        { src=gh('tpope/vim-fugitive') },
        { src=gh('tpope/vim-surround') },

        { src=gh('ThePrimeagen/vim-be-good') },
})
