local cmp = require('cmp')

cmp.setup({
	sources = {
		{name = 'nvim_lsp'},
	},
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if cmp.get_selected_entry() then
					-- If an item is already selected, confirm it
					cmp.confirm({ select = false })
				else
					-- If no item is selected, move to the next one
					cmp.select_next_item()
					cmp.confirm({ select = true })
				end
			else
				-- Otherwise, insert a regular tab character
				fallback()
			end
		end, { 'i', 's' }),
	}),
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
})

