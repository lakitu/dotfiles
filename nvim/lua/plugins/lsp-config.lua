local lspconfig = require("lspconfig")

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
        vim.keymap.set('n', '<leader>td', function()
            -- vim.diagnostic.enable(not vim.diagnostic.is_enabled())
            if vim.diagnostic.is_enabled() then
                vim.diagnostic.enable(false)
                print("Diagnostics disabled")
            else
                vim.diagnostic.enable(true)
                print("Diagnostics enabled")
            end
        end, { noremap = true, silent = true })

        print("LSP Attached")
    end,
})


require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        function(server_name)
            lspconfig[server_name].setup({})
        end,
    }
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
    cmd = { vim.fn.stdpath("data") .. "/mason/packages/clangd/clangd_19.1.2/bin/clangd", "--query-driver=C:/ProgramData/mingw64/mingw64/bin/gcc.exe" },
});

lspconfig.ocamllsp.setup({
    cmd = { "opam", "exec", "--", "ocamllsp" },
    filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
    root_dir = lspconfig.util.root_pattern("*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace"),
});

