call plug#begin('~/.vim/plugged')
    Plug 'junegunn/vim-plug'

    Plug 'JamshedVesuna/vim-markdown-preview'
    Plug 'SirVer/ultisnips'
    Plug 'benmills/vimux'
    Plug 'brianclements/vim-lilypond'
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'glepnir/galaxyline.nvim', { 'branch': 'main' }
    Plug 'nvim-lua/completion-nvim'
    Plug 'steelsojka/completion-buffers'
    Plug 'janko/vim-test'
    Plug 'joshdick/onedark.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'lifepillar/vim-solarized8'
    Plug 'majutsushi/tagbar'
    Plug 'mhinz/vim-grepper'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'mhinz/vim-signify'
    Plug 'mhinz/vim-startify'
    Plug 'milkypostman/vim-togglelist'
    Plug 'mtth/scratch.vim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-rhubarb'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'trayo/vim-ginkgo-snippets'
    Plug 'trayo/vim-gomega-snippets'
call plug#end()

let mapleader=' '
let maplocalleader='\'

set completeopt=menuone,noselect,noinsert
set cursorline
set encoding=utf8
set expandtab
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
set shiftwidth=4
set showmatch
set signcolumn=yes:1
set smartcase
set softtabstop=4
set splitbelow
set splitright
set tabstop=4
set termguicolors
set textwidth=0
set undofile
set wildmenu
set wildmode=longest,list:longest

colorscheme onedark

nmap <silent> <leader>ve :edit ~/.config/nvim/init.vim<CR>
nmap <silent> <leader>vs :source ~/.config/nvim/init.vim<CR>

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
autocmd BufWritePre *.go lua LSP_organize_imports()
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.rb lua vim.lsp.buf.formatting_sync(nil, 1000)

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


autocmd BufEnter * lua require'completion'.on_attach()
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet', 'buffers']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]

let g:fzf_layout = { 'down': '~30%' }
let g:fzf_buffers_jump = 1

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
