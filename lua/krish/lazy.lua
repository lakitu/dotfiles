-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('lazy').setup({
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { {'nvim-lua/plenary.nvim'} },
        config = function()
            require('plugins.telescope')
        end,
    },

    { 'yorickpeterse/happy_hacking.vim', name="happy-hacking" },
    { 'sainnhe/gruvbox-material', name="gruvbox-material" },
    { 'morhetz/gruvbox', name="gruvbox" },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup()
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('plugins.treesitter')
        end,
    },

    {
        'theprimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('plugins.harpoon')
        end,
    },

    {
        'mbbill/undotree',
        --		cmd = 'UndotreeToggle',
        config = function()
            vim.keymap.set ("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },

    {
        'tpope/vim-fugitive',
        cmd = { 'Git' },
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
        end,
    },

    -- commenting plugin
    {
        'numToStr/Comment.nvim',
        opts = {},
        config = function()
            require('plugins.comment')
        end,
        keys = {
            { '<C-_>', mode = { 'n', 'v' } },  -- Make sure it's available in both normal and visual mode
            { '<C-/>', mode = { 'n', 'v' } },  -- Lazy-load when these keys are pressed
        },
    },

    -- LSP and autocomplete
    {
        -- LSP
        {
            'neovim/nvim-lspconfig',
            cmd = {'LspInfo', 'LspInstall', 'LspStart'},
            event = {'BufReadPre', 'BufNewFile'},
            dependencies = {
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'williamboman/mason.nvim', },
                { 
                    'williamboman/mason-lspconfig.nvim', 
                    config = function()
                        require("mason").setup()
                        require("mason-lspconfig").setup()
                    end
                },
            },
        },

        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            config = function()
                require("plugins.cmp")
            end
        },
    },

    {
        "ThePrimeagen/vim-be-good",
        cmd = { 'VimBeGood' },
    },
})
