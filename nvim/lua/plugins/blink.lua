return {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        build = "cargo build --release",
        opts = {
                fuzzy = { implementation = "prefer_rust", },
                completion = {
                        ghost_text = {
                                enabled = true,
                                show_with_menu = false,
                        },
                        menu = {
                                auto_show = false,
                        },
                },
                keymap = {
                        preset = 'default',

                        ['<C-j>'] = {'select_next', 'fallback'},
                        ['<C-k>'] = {'select_prev', 'fallback'},
                        ['<Tab>'] = {'accept', 'fallback'},
                },
        }
}
