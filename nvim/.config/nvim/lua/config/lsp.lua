local nvim_lsp = require 'lspconfig'

-- disable inline diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
		underline = true,
		signs = true,
    }
)

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>ee', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>ef', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>ea', '<cmd>lua vim.diagnostic.setqflist({workspace = true})<CR>', opts)

local on_attach = function(client, bufnr)

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('v', '<leader>ca', ':<C-U>Lspsaga range_code_action<CR>', opts)


end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local coq = require("coq")
local servers = { "tsserver", "bashls" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup(coq.lsp_ensure_capabilities(
    vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {debounce_text_changes = 150},
    }, {})))
end

nvim_lsp.gopls.setup(coq.lsp_ensure_capabilities(
vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    cmd = { 'gopls', '--remote=auto' },
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            gofumpt = true,
            buildFlags = {"-tags=e2e"},
        }
    },
    capabilities = capabilities,
    flags = {debounce_text_changes = 150},
}, {})))

