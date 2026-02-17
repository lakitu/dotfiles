-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('lazy').setup({
        -- file navigation 
        {
                'nvim-telescope/telescope.nvim',
                tag = '0.1.8',
                dependencies = { {'nvim-lua/plenary.nvim'} },
                config = function()
                        require('plugins.telescope')
                end,
        },

        {
                'stevearc/oil.nvim',
                lazy=false,
                opts = {
                        view_options = {
                                show_hidden = true,
                                natural_order = true,
                        },
                },
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
                        { 'williamboman/mason.nvim', },
                        { 'mason-org/mason-lspconfig.nvim', },
                        -- autcomplete
                        {
                                'saghen/blink.cmp',
                                -- optional: provides snippets for the snippet source
                                dependencies = { 'rafamadriz/friendly-snippets' },
                                build = "cargo build --release",
                                opts = {
                                        fuzzy = { implementation = "prefer_rust", },
                                        ghost_text = {
                                                enabled = true,
                                                show_with_menu = false,
                                        },
                                        menu = {
                                                auto_show = false,
                                        },
                                        keymap = {
                                                preset = 'default',

                                                ['<C-j>'] = {'select_next', 'fallback'},
                                                ['<C-k>'] = {'select_prev', 'fallback'},
                                                ['<Tab>'] = {'accept', 'fallback'},
					},
                                }
                        }
                },
                config = function()
                        require("plugins.lsp-config")
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
                "ThePrimeagen/vim-be-good",
                cmd = { 'VimBeGood' },
        },
})
