lua require('plugins')

let mapleader=' '
let maplocalleader='\'

set cursorline
set encoding=utf8

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set foldenable
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
set foldmethod=expr

set hidden
set hlsearch
set inccommand=nosplit
set incsearch
set listchars=tab:▸\ ,trail:~,extends:>,precedes:<,space:·
set maxmempattern=2000
set mouse=a
set noshowmode
set number
set showmatch
set signcolumn=yes:1
set smartcase
set splitbelow
set splitright
set termguicolors
set textwidth=0
set undofile
" set wildmenu
" set wildmode=longest,list:longest

colorscheme onedark

" completion-nvim
set completeopt=menuone,noinsert,noselect
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set shortmess+=c
let g:completion_enable_snippet = 'UltiSnips'
autocmd BufEnter * lua require'completion'.on_attach()

" trigger CursorHold in 500ms and show error popup if error on line
set updatetime=500
autocmd CursorHold * Lspsaga show_line_diagnostics

" shfmt scripts - use 2 spaces for indent, and fmt on save
let g:shfmt_fmt_on_save = 1
let g:shfmt_extra_args = '-i 2'

" restore file cursor position
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

nmap <silent> <leader>ve :edit $MYVIMRC<CR>
nmap <silent> <leader>vs :source $MYVIMRC<CR>

nnoremap <silent> <leader>ss :Grepper -tool rg<cr>

autocmd BufWritePre * FixWhitespace

nnoremap j gj
nnoremap k gk

function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()

vnoremap > >gv
vnoremap < <gv

" =======================================================================================
" =============================== PLUGIN CONFIGURATIONS =================================
" =======================================================================================
"
function! NERDTreeToggleAndFind()
  if (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
    execute ':NERDTreeClose'
  else
    if (expand("%:t") != '')
        execute ':NERDTreeFind'
    else
        execute ':NERDTreeToggle'
    endif
  endif
endfunction

nnoremap <silent> \ :NERDTreeToggle<CR>
nnoremap <silent> \| :NERDTreeFind<cr>

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1

autocmd FileType nerdtree setlocal nolist

set laststatus=2

let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<Leader>mp'
let vim_markdown_preview_browser='Firefox'

nnoremap <unique> <expr> <CR> empty(&buftype) ? ':w<CR>' : '<CR>'
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 10000); LSP_organize_imports()
autocmd BufWritePre *.rb lua vim.lsp.buf.formatting_sync(nil, 3000)

lua require('config.lsp')
lua require('config.galaxyline')

lua << EOF
    require'nvim-treesitter.configs'.setup {
      ensure_installed = {"go", "ruby", "c", "bash", "lua", "yaml", "javascript", "html"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      highlight = {
        enable = true,              -- false will disable the whole extension
        -- disable = { "c", "rust" },  -- list of language that will be disabled
      },
      indent = {
        enable = true,
      },
    }
EOF


let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

let g:fzf_layout = { 'down': '~30%' }
let g:fzf_buffers_jump = 1

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

augroup fzf
  autocmd!
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <leader>fo :Buffers<cr>
nnoremap <silent> <leader>fm :History<cr>
nnoremap <silent> <leader>fd :bp\|bd #<cr>
nnoremap <silent> <leader>fn :bn<cr>
nnoremap <silent> <leader>fp :bp<cr>
nnoremap <silent> <leader>fa :A<cr>
nnoremap <silent> <leader>m `

let g:startify_custom_header = map(systemlist('fortune | cowsay'), '"               ". v:val')
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 0
let g:startify_lists = [
                  \ { 'type': 'dir',       'header': [   'MRU ' . getcwd()] },
                  \ { 'type': 'files',     'header': [   'MRU']             },
                  \ { 'type': 'sessions',  'header': [   'Sessions']        },
                  \ { 'type': 'bookmarks', 'header': [   'Bookmarks']       },
                  \ { 'type': 'commands',  'header': [   'Commands']        },
                  \ ]

if empty($TMUX)
  let g:test#strategy = 'neoterm'
else
  let g:test#strategy = 'vimux'
endif

function! ScriptTestTransform(cmd) abort
  let l:command = a:cmd

  let l:commandTail = split(a:cmd)[-1]
  if &filetype == 'go'
    if filereadable('scripts/test')
      let l:command = 'scripts/test ' . l:commandTail
    end
  end

  return l:command
endfunction

let g:test#custom_transformations = {'scripttest': function('ScriptTestTransform')}
let g:test#transformation = 'scripttest'
nnoremap <silent> <leader>tt :TestNearest<cr>
nnoremap <silent> <leader>t. :TestLast<cr>
nnoremap <silent> <leader>tf :TestFile<cr>
nnoremap <silent> <leader>ts :TestSuite<cr>
nnoremap <silent> <leader>tg :TestVisit<cr>

nmap <silent> <leader>gh :Gbrowse<cr>
vmap <silent> <leader>gh :Gbrowse<cr>

nnoremap <silent> <F8> :TagbarToggle<cr>
