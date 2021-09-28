local nvim_lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'
local saga = require'lspsaga'

lsp_status.config{
    status_symbol = '',
    current_function = false,
    indicator_errors = '❌',
    indicator_warnings = '⚠',
    indicator_info = 'ℹ',
    indicator_hint = '💡',
    indicator_ok = '✔️',
}
lsp_status.register_progress()
saga.init_lsp_saga()

-- disable inline diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
		underline = true,
		signs = true,
    }
)

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    -- buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gh', ':Lspsaga lsp_finder<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', ':Lspsaga hover_doc<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gs', ':Lspsaga signature_help<CR>', opts)
    buf_set_keymap('n', '<leader>ca', ':Lspsaga code_action<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', ':Lspsaga rename<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', ':Lspsaga show_line_diagnostics<CR>', opts)
    buf_set_keymap('n', '[g', ':Lspsaga diagnostic_jump_prev<CR>', opts)
    buf_set_keymap('n', ']g', ':Lspsaga diagnostic_jump_next<CR>', opts)
    buf_set_keymap('n', '<leader>db', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>da', '<cmd>lua vim.lsp.diagnostic.set_loclist({workspace = true})<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    lsp_status.on_attach(client)
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "tsserver", "bashls" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach, capabilities = lsp_status.capabilities }
end

nvim_lsp.gopls.setup{
    on_attach = on_attach;
    capabilities = lsp_status.capabilities;
    cmd = { 'gopls', '--remote=auto' };
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            gofumpt = true,
            buildFlags = {"-tags=seccomp"},
        }
    };
}
local sumneko_root_path = '/home/kieron/src/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/Linux/lua-language-server"

require('lspconfig').sumneko_lua.setup({
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    -- An example of settings for an LSP server.
    --    For more options, see nvim-lspconfig
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        }
    };

    on_attach = on_attach;
    capabilities = lsp_status.capabilities;
})

require'lspconfig'.java_language_server.setup({
    on_attach = on_attach;
    capabilities = lsp_status.capabilities;
    cmd = {vim.env.HOME.."/src/java-language-server/dist/lang_server_linux.sh"};
})

require'lspconfig'.solargraph.setup {
    on_attach = on_attach;
    capabilities = lsp_status.capabilities;
    cmd = { "solargraph", "stdio" };
    filetypes = { "ruby" };
    -- root_dir = root_pattern("Gemfile", ".git");
    settings = { solargraph = {
        diagnostics = true,
        formatting = true,
        autoformatting = true
    } };
}

-- Call before saving go files to add/remove imports automatically
function LSP_organize_imports()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit)
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end
