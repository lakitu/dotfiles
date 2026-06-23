require("mason").setup()
--require("lsp-config").setup()
require("mason-lspconfig").setup()

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

                for _, map in ipairs(keymaps) do
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

vim.lsp.config('*', {
        capabilities=capabilities,
})

vim.lsp.config("lua_ls", {
        capabilities=capabilities,
        root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
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
                vim.fn.stdpath("data") .. "/mason/bin/clangd.cmd",
                "--query-driver=C:/ProgramData/mingw64/mingw64/bin/g*.exe"
        },
})

vim.lsp.config("ocamllsp", {
        capabilities=capabilities,
        cmd = { "opam", "exec", "--", "ocamllsp" },
        filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
        root_markers = { "*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace" },
})

require('nvim-treesitter.install').compilers = { 'gcc' }

-- require('nvim-treesitter').install({ 'python', 'rust', 'javascript', 'typescript' })


-- -- antlr4 tree-sitter setup
-- -- 1. add the grammar dir to runtimepath
-- vim.opt.runtimepath:append("C:/Users/krish/Desktop/development/antlr4/tree-sitter-antlr4")
--
-- -- 2. register the parser and enable highlighting for .g4 files
-- vim.filetype.add({ extension = { g4 = "antlr4" } })
-- vim.treesitter.language.add("antlr4", { path="C:/Users/krish/Desktop/development/antlr4/tree-sitter-antlr4/antlr4.dll" })
--
-- vim.api.nvim_create_autocmd("FileType", {
--         pattern = "antlr4",
--         callback = function() vim.treesitter.start() end,
-- })
--
-- require("nvim-treesitter.parsers").antlr4 = {
--         install_info = {
--                 url = "C:/Users/krish/Desktop/development/antlr4/tree-sitter-antlr4",
--                 files = { "src/parser.c" },
--                 generate_requires_npm = false,
--                 requires_generate_from_grammar = false,
--         },
--         filetype = "antlr4",
-- }
--
--
-- vim.lsp.enable(servers)
