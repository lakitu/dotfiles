return {
    fuzzy = {
        implementation = "prefer_rust",
    },

    completion = {
        -- ghost_text = {
            --         enabled = true,
            --         show_with_menu = false,
            -- },
            -- menu = {
                --         auto_show = false,
                -- },
                menu = {
                    auto_show = function()
                        return not vim.tbl_contains({
                            -- "tex",
                            ""
                        }, vim.bo.filetype)
                        end,
                },
            },

            keymap = {
                preset = 'default',

                ['<C-j>'] = {'select_next', 'fallback'},
                ['<C-k>'] = {'select_prev', 'fallback'},
                ['<Tab>'] = {'accept', 'fallback'},
                ['<C-h>'] = { "show", "show_documentation", "hide_documentation" },
                -- ['<CR>'] =  {"fallback"},
                -- { 
                --     function(cmp) 
                --         cmp.show({ providers = { 'snippets' } }) 
                --     end 
                -- },
            },

            -- per_filetype = {
            --     tex = {
            --         completion = {
            --             menu = {
            --                 auto_show = false,
            --             }
            --         }
            --     }
            -- },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        }
