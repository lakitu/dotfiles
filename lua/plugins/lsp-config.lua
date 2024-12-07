local lspconfig = require("lspconfig")
-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = lspconfig.util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    -- <leader>td turns off diagnostics
    local diagnostics_active = true
    vim.keymap.set('n', '<leader>td', function()
	    diagnostics_active = not diagnostics_active
	    if diagnostics_active then
		    vim.diagnostic.enable()
		    print("Diagnostics enabled")
	    else
		    vim.diagnostic.disable()
		    print("Diagnostics disabled")
	    end
    end, { noremap = true, silent = true })

    print("LSP Attached")
  end,
})


require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	}
})

lspconfig.eslint.setup({
	cmd = { "vscode-eslint-language-server", "--stdio" },
	version = { "vscode-eslint-language-server", "--stdio", "--version"},
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = function() return vim.loop.cwd() end,      -- run lsp for javascript in any directory
	-- root_dir = function(fname)
	-- 	return lspconfig.util.root_pattern(".eslintrc*", "package.json", ".git")(fname)
	-- 	or lspconfig.util.find_git_ancestor(fname)
	-- 	or lspconfig.util.path.dirname(fname)
	-- end,
	on_attach = function(client, bufnr)
		print("ESLint attached to buffer " .. bufnr)
	end,
	settings = {
		format = { enable = true },
		eslint = {
			nodePath = "C:/Program Files/nodejs/node_modules",
			useESLintClass = true,
			trace = { server = 'verbose' },
		},
	},
	capabilities = require('cmp_nvim_lsp').default_capabilities()
})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = {'vim'}
			}
		}
	},
})

lspconfig.clangd.setup({
	cmd = { "clangd", "--query-driver=C:/ProgramData/mingw64/mingw64/" },
});

