-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('lazy').setup({
        -- telescope
        {
                'nvim-telescope/telescope.nvim',
                tag = '0.1.8',
                dependencies = { {'nvim-lua/plenary.nvim'} },
                config = function()
                        require('plugins.telescope')
                end,
        },

        -- themes
        { 'yorickpeterse/happy_hacking.vim', name="happy-hacking" },
        {
                'comfysage/evergarden', name="evergarden",
                opts = {
                        variant = 'medium'
                }
        },
        {
                "jackplus-xyz/binary.nvim", name="binary",
                opts = {
                        style = "light",
                        colors = {
                                fg = "#303843",
                                bg = "#efeceb",
                        },
                },
        },
        { 'projekt0n/github-nvim-theme', name="github" },

        -- decoration (bottom bar)
        {
                'nvim-lualine/lualine.nvim',
                dependencies = { 'nvim-tree/nvim-web-devicons' },
                config = function()
                        require('lualine').setup()
                end,
        },

        -- lsp support
        {
                'nvim-treesitter/nvim-treesitter',
                build = ':TSUpdate',
                event = { "BufReadPost", "BufNewFile" },
                config = function()
                        require('plugins.treesitter')
                end,
        },


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


        -- convenience
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
                'folke/trouble.nvim',
                cmd='Trouble',
                opts=function() return require('plugins.trouble').opts end,
                keys=function() return require('plugins.trouble').keys end,
        },
        {
                'tpope/vim-fugitive',
                cmd = { 'Git' },
        },
        { 'tpope/vim-surround', },

        -- commenting plugin
        {
                'numToStr/Comment.nvim',
                opts = {},
                config = function()
                        require('plugins.comment')
                end,
                keys = {
                        { '<C-_>', mode = { 'n', 'v' } },
                        { '<C-/>', mode = { 'n', 'v' } },
                },
        },

        {
                'stevearc/oil.nvim',
                ---@module 'oil'
                ---@type oil.SetupOpts
                opts = {},
        },

        {
                "ThePrimeagen/vim-be-good",
                cmd = { 'VimBeGood' },
        },
})
