call plug#begin('~/.vim/plugged')
    Plug 'junegunn/vim-plug'

    Plug 'JamshedVesuna/vim-markdown-preview'
    Plug 'SirVer/ultisnips'
    Plug 'benmills/vimux'
    Plug 'brianclements/vim-lilypond'
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'glepnir/galaxyline.nvim', { 'branch': 'main' }
    Plug 'hrsh7th/nvim-compe'
    " Plug 'itchyny/lightline.vim'
    Plug 'janko/vim-test'
    Plug 'joshdick/onedark.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'lifepillar/vim-solarized8'
    Plug 'majutsushi/tagbar'
    Plug 'mhinz/vim-grepper'
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

set completeopt=menuone,noselect
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

colorscheme solarized8_high

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

nnoremap <cr> :w<cr>
autocmd BufWritePre *.go lua lsp_organize_imports()
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.rb lua vim.lsp.buf.formatting_sync(nil, 1000)

lua require('config.lsp')
lua require('config.galaxyline')

lua << EOF
    require'nvim-treesitter.configs'.setup {
      ensure_installed = {"go", "ruby", "c", "bash", "lua", "yaml", "javascript"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
" let g:compe.source.calc = v:true
" let g:compe.source.vsnip = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.spell = v:true
" let g:compe.source.tags = v:true
" let g:compe.source.snippets_nvim = v:true
let g:compe.source.treesitter = v:true
let g:compe.source.omni = v:true
let g:compe.source.ultisnips = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <C-y>      compe#confirm('<CR>')

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
