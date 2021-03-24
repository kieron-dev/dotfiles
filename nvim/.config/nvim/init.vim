" ------------------------------ PLUGINS ------------------------------
call plug#begin('~/.vim/plugged')
    Plug 'benmills/vimux'                                             " Allow vim to do tmux stuff, like open panes for the test plugin
    Plug 'bronson/vim-trailing-whitespace'
    " Plug 'christoomey/vim-system-copy'                                " Add mappings to copy to clipboard
    Plug 'christoomey/vim-tmux-navigator'                             " Navigate through vim splits seamlessly
    " Plug 'fatih/vim-go'                                               " Golang plugin
    Plug 'itchyny/lightline.vim'                                      " Light and configurable statusline
    Plug 'JamshedVesuna/vim-markdown-preview'                         " Preview markdown files in the browser
    Plug 'janko/vim-test'                                             " Test runner integration
    " Plug 'josharian/impl'                                             " Generates method stubs for implementing an interface
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Awesome fuzzy finder
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-plug'                                          " This plugin manager
    Plug 'majutsushi/tagbar'                                          " Outline viewer for vim
    Plug 'mhinz/vim-grepper'
    Plug 'mhinz/vim-signify'                                          " Show git diff in the sign column
    Plug 'mhinz/vim-startify'                                         " Fancy start screen
    Plug 'milkypostman/vim-togglelist'                                " Toggle quickfix and location windows
    Plug 'mtth/scratch.vim'                                           " Unobtrusive scratch window
    Plug 'nanotech/jellybeans.vim'                                    " My current colorscheme
    " Plug 'neoclide/coc.nvim', {'branch':'release' }

    Plug 'neovim/nvim-lspconfig'
    " Plug 'nvim-lua/completion-nvim'
    Plug 'hrsh7th/nvim-compe'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Plug 'glepnir/lspsaga.nvim'

    " Plug 'powerman/vim-plugin-AnsiEsc'                                " ANSI escape sequences concealed, but highlighted as specified
    " Plug 'rhysd/git-messenger.vim'                                    " Reveal the commit messages under the cursor in a 'popup window'
    " Plug 'romainl/vim-cool'                                           " Make hlsearch more useful
    " Plug 'RRethy/vim-illuminate'                                      " Selectively illuminating other uses of the current word under the cursor
    Plug 'scrooloose/nerdtree'                                        " Directory tree explorer
    Plug 'SirVer/ultisnips'                                           " Add various code snippets
    Plug 'tpope/vim-commentary'                                       " Comment stuff out
    Plug 'tpope/vim-eunuch'                                           " Unix utility commands
    Plug 'tpope/vim-fugitive'                                         " Git wrapper
    Plug 'tpope/vim-repeat'                                           " Make . work with tpope's plugins
    Plug 'tpope/vim-rhubarb'                                          " Open selected code in githb in browser
    Plug 'tpope/vim-surround'                                         " Provides mappings to easily delete, change and add surroundings (parentheses, brackets, quotes, XML tags, and more) in pairs
    Plug 'tpope/vim-unimpaired'                                       " Useful mappings
    Plug 'trayo/vim-ginkgo-snippets'                                  " Add snippets for Ginkgo BDD testing library for go
    Plug 'trayo/vim-gomega-snippets'
    Plug 'vim-ruby/vim-ruby'                                          " Ruby plugin
    Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }                          " Runs shfmt to auto format the current buffer
    Plug 'zhimsel/vim-stay'                                           " Remember cursor, folds, etc
    Plug 'brianclements/vim-lilypond'
call plug#end()
" ---------------------------------------------------------------------

" ------------------------------ GENERAL ------------------------------
set mouse=a                                                           "Enable mouse
set backspace=indent,eol,start                                        "Make backspace normal
set nocompatible                                                      "Disable vi compatibility. Because we're not in 1995
set tw=0                                                              "Disable automactic line wrapping
set listchars=tab:▸\ ,trail:~,extends:>,precedes:<,space:·            "Specify whitespace characters visualization
set encoding=utf8                                                     "Encoding
set ffs=unix,dos                                                      "File formats that will be tried (in order) when vim reads and writes to a file
set splitbelow                                                        "Set preview window position to bottom of the page
set splitright
set scrolloff=5                                                       "Show at least N lines above/below the cursor.
set hidden                                                            "Opening a new file when the current buffer has unsaved changes causes files to be hidden instead of closed
set undolevels=1000                                                   "Undo many times
set undofile                                                          "Undo across vim sessions
set noshowmode                                                        "Do not show message on last line when in Insert, Replace or Visual mode
set termguicolors                                                     "Enable TrueColor
set inccommand=nosplit                                                "Shows the effects of a command incrementally, as you type

if !has('nvim')
  set ttymouse=sgr                                                    "Make the mouse work even in columns beyond 223
endif

let mapleader=' '
let maplocalleader='\'

" Increase the maximum amount of memory to use for pattern matching
set maxmempattern=2000

" vimrc key mappings
nmap <silent> <leader>ve :edit ~/.config/nvim/init.vim<CR>
nmap <silent> <leader>vs :source ~/.config/nvim/init.vim<CR>

" search mappings
nnoremap <silent> <leader>ss :Grepper -tool rg<cr>
nnoremap <leader>sr :Rg

" autoremove trailing whitespace
autocmd BufWritePre * FixWhitespace

" shell-like navigation while in normal mode
inoremap <c-b> <c-\><c-o>h
inoremap <c-f> <c-\><c-o>l
" ---------------------------------------------------------------------

" ------------------------------ COLORS ------------------------------
"Enable syntax processing
syntax enable

colorscheme jellybeans

" Because jellybeans shows wrong background colors for whitespace characters  on current line
highlight NonText guibg=NONE
highlight LineNr guifg=#545252 guibg=#1c1c1c
highlight CursorLine guibg=#232323
highlight CursorLineNr guibg=#1c1c1c guifg=#6A95EA
highlight SpecialKey guifg=grey35
highlight Search gui=bold guifg=#000000 guibg=#6A95EA
highlight VertSplit guifg=#1c1c1c guibg=#1c1c1c
highlight SignColumn term=standout guifg=#777777 guibg=#1c1c1c
highlight StatusLineNC guibg=#1c1c1c
highlight StatusLine gui=italic guifg=grey guibg=#1c1c1c


" ------------------------------ SPACES & TABS -----------------------------
set tabstop=4               "Number of visual spaces per TAB
set softtabstop=4           "Number of spaces in tab when editing
set expandtab               "Tabs are spaces
set shiftwidth=4            "Indent with 4 spaces
" ---------------------------------------------------------------------

" ------------------------------ UI CONFIG ------------------------------
set number                              "Show line numbers
filetype indent on                      "Load filetype-specific indent files
set wildmenu                            "Visual autocomplete for command menu
set wildmode=longest,list:longest
set completeopt=menuone,noselect
" set shortmess+=c
" set lazyredraw                          "Redraw only when we need to.
set showmatch                           "Highlight matching [{()}]
set fillchars+=vert:│                   "Solid vertical split line
set cursorline                          "Highlight current line

augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
" ---------------------------------------------------------------------

" ------------------------------ SEARCHING ------------------------------
set incsearch
set hlsearch
set smartcase
" ---------------------------------------------------------------------

" ------------------------------ FOLDING ------------------------------
set foldenable              "Enable folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99       "Do not close folds when a buffer is opened
" ---------------------------------------------------------------------

" ------------------------------ MOVEMENT ------------------------------
"Move vertically (down) by visual line
nnoremap j gj
nnoremap k gk

" ---------------------------------------------------------------------


" ------------------------------ SANE PASTING---------------------------
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
" ---------------------------------------------------------------------

" ------------------------------ CONTINUE INDENTING---------------------
vnoremap > >gv
vnoremap < <gv
" ---------------------------------------------------------------------

" =======================================================================================
" =============================== PLUGIN CONFIGURATIONS =================================
" =======================================================================================

" --------------------------------- NERDTree -------------------------------

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

" Toggle NERDTree
nnoremap <C-n> :call NERDTreeToggleAndFind()<CR>
nnoremap <silent> \ :NERDTreeToggle<CR>
nnoremap <silent> \| :NERDTreeFind<cr>

" Single mouse click will open any node
let g:NERDTreeMouseMode=3

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Automatically delete the buffer of the file you just deleted with NerdTree
let NERDTreeAutoDeleteBuffer = 1

" Hide 'Press ? for help' and bookmarks
let NERDTreeMinimalUI = 1

" Expand directory symbols
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Do not show whitespace characters in NERDTree window
autocmd FileType nerdtree setlocal nolist

" Show hidden files
let NERDTreeShowHidden=1

" --------------------------------------------------------------------------

" --------------------------------- Lightline --------------------------------

" Show statusline
set laststatus=2

" Colors
let s:green = [ '#99ad6a', 107 ]
let s:red = [ '#dd1c1c', 167 ]
let s:yellow = [ '#ffb964', 215 ]
let s:blue = [ '#6A95EA', 103, 'bold' ]
let s:lightgrey = [ '#999494', 'none' ]
let s:blackish = [ '#1c1c1c', 'none' ]
let s:darkgrey = [ '#282525', 'none' ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

" Middle
let s:p.normal.middle = [ [ s:lightgrey, s:blackish ] ]

" Left
let s:p.normal.left = [ [ s:blue, s:blackish ], [ s:green, s:blackish ], [ s:red, s:blackish ], [ s:lightgrey, s:blackish ] ]
let s:p.insert.left = [ [ s:blue, s:blackish ], [ s:green, s:blackish ], [ s:red, s:blackish ], [ s:lightgrey, s:blackish ] ]
let s:p.replace.left = [ [ s:blue, s:blackish ], [ s:green, s:blackish ], [ s:red, s:blackish ], [ s:lightgrey, s:blackish ] ]
let s:p.visual.left = [ [ s:blue, s:blackish ], [ s:green, s:blackish ], [ s:red, s:blackish ], [ s:lightgrey, s:blackish ] ]

" Right
let s:p.normal.right = [ [ s:lightgrey, s:blackish ], [ s:lightgrey, s:blackish ], [ s:lightgrey, s:blackish ] ]

" Inactive
let s:p.inactive.middle = [ [ s:lightgrey, s:darkgrey ] ]
let s:p.inactive.right = [ [ s:darkgrey, s:darkgrey ], [ s:darkgrey, s:darkgrey ] ]

" Errors & warnings
let s:p.normal.error = [ [ s:red, s:blackish ] ]
let s:p.normal.warning = [ [ s:yellow, s:blackish ] ]

" Tabs
let s:p.tabline.left = [ [ s:lightgrey, s:blackish ] ]
let s:p.tabline.tabsel = [ [ s:blue, s:blackish ] ]

" Set the palette
let g:lightline#colorscheme#jellybeans#palette = lightline#colorscheme#flatten(s:p)

" Lightline configs
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch' ],
      \             [ 'readonly' ],
      \             [ 'relativepath', 'modified' ] ],
      \   'right': [ [ 'cocstatus'],
      \              [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype', 'encodingformat' ] ],
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'gitbranch': 'LightlineBranch',
      \   'mode': 'LightlineMode',
      \   'encodingformat': 'LightlineFileEncodingFormat',
      \   'lineinfo': 'LightlineLineInfo',
      \   'percent': 'LightlinePercent',
      \   'filetype': 'LightlineFiletype',
      \   'relativepath': 'LightlineRelativePath',
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \ },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ }

" Custom functions
function! LightlineBranch()
  if &ft == 'nerdtree'
    return ''
  endif
  let branch = fugitive#head()
  return branch !=# '' ? ' ' . branch : ''
endfunction

function! LightlineMode()
  if &ft == 'nerdtree'
    return '« NERD »'
  endif
  return '« ' . lightline#mode() . ' »'
endfunction

function! LightlineFileEncodingFormat()
  if &ft == 'nerdtree'
    return ''
  endif
  let encoding = &fenc!=#""?&fenc:&enc
  let format = &ff
  return encoding . '[' . format . ']'
endfunction

function! LightlineLineInfo()
  if &ft == 'nerdtree'
    return ''
  endif
  return line('.').':'. col('.')
endfunction

function! LightlinePercent()
  if &ft == 'nerdtree'
    return ''
  endif
  return line('.') * 100 / line('$') . '%'
endfunction

function! LightlineFiletype()
  if &ft == 'nerdtree'
    return ''
  endif
  return &ft !=# "" ? &ft : "no ft"
endfunction

function! LightlineRelativePath()
  if &ft == 'nerdtree'
    return ''
  endif
  return expand("%")
endfunction

function! LightlineModified()
  if &ft == 'nerdtree'
    return ''
  endif
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  if &ft == 'nerdtree'
    return ''
  endif
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction
" --------------------------------------------------------------------------


" --------------------------------- Vim-Markdown-Preview --------------------------------

" Use Chrome
let vim_markdown_preview_browser='Google Chrome'

" Use github syntax
let vim_markdown_preview_github=1

" Leave Ctrl-P alone
let vim_markdown_preview_hotkey='<Leader>mp'

" --------------------------------------------------------------------------


" --------------------------------- Shfmt  -------------------------------
" Use 2 spaces instead of tabs
let g:shfmt_extra_args = '-i 2 -ci'
let g:shfmt_fmt_on_save = 1
" --------------------------------------------------------------------------

" ----- <CR> saves ----
nnoremap <cr> :w<cr>
autocmd BufWritePre *.go lua lsp_organize_imports()
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
autocmd BufWritePre *.rb lua vim.lsp.buf.formatting_sync(nil, 1000)

" --------------------------------- LSP ------------------------------
lua require('lsp')

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


" autocmd BufEnter * lua require'completion'.on_attach()
" let g:completion_enable_auto_hover = 0
" let g:completion_enable_snippet = 'UltiSnips'
let g:UltiSnipsExpandTrigger = '<c-j>'
" let g:UltiSnipsListSnippets = '<c-tab>'
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

" --------------------------------------------------------------------------


" --------------------------------- FuzzyFind  -----------------------------
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_buffers_jump = 1

" Show preview when searching files
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Use Rg for searching for contents and show preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!vendor/" '.shellescape(<q-args>), 1,
  \    fzf#vim#with_preview({'down': '60%', 'options': '--bind alt-down:preview-down --bind alt-up:preview-up'},'right:50%', '?'),
  \   <bang>0)

" hide the statusline of the containing buffer
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
" --------------------------------------------------------------------------
"
" -------------------------------- Startify --------------------------------
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
" --------------------------------------------------------------------------

" ------------------ Testing -----------------------------------------------
if empty($TMUX)
  let g:test#strategy = 'neoterm'
else
  let g:test#strategy = 'vimux'
endif

"" We can customise tests requiring setup as below...
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
" --------------------------------------------------------------------------
"
" -------------------------------- vim-rhubarb -----------------------------
" open in github
nmap <silent> <leader>gh :Gbrowse<cr>
vmap <silent> <leader>gh :Gbrowse<cr>
" --------------------------------------------------------------------------