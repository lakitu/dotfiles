local keymaps = {
                { 'K', '<cmd>lua vim.lsp.buf.hover()<cr>' },
                { 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>' },
                { 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>' },
                { 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>' },
                { 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>' },
                { 'gr', '<cmd>lua vim.lsp.buf.references()<cr>' },
                { 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>' },
                { '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>' },
                { '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>' },
                { '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>' }
}

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
                -- keymaps
                local opts = { buffer = event.buf }

                for map in keymaps do
                        vim.keymap.set('n', map[1], map[2], opts)
                end

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


local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = require("mason-lspconfig").get_installed_servers()

for _, server in ipairs(servers) do
        vim.lsp.config(server, {
                capabilities=capabilities,
        })
end

vim.lsp.config("lua_ls", {
        capabilities=capabilities,
        settings = {
                Lua = {
                        diagnostics = {
                                globals = {'vim'}
                        }
                }
        }
})

vim.lsp.config("clangd", {
        capabilities=capabilities,
        cmd = {
                vim.fn.stdpath("data") .. "/mason/packages/clangd/clangd_21.1.8/bin/clangd",
                "--query-driver=C:/ProgramData/mingw64/mingw64/bin/gcc.exe"
        },
})

vim.lsp.config("ocamllsp", {
        capabilities=capabilities,
        cmd = { "opam", "exec", "--", "ocamllsp" },
        filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
        root_markers = { "*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace" },
})

vim.lsp.enable(servers)
