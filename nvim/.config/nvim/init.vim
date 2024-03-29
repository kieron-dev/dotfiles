source $HOME/.config/nvim/plug.vim

" ------------------------------ GENERAL ------------------------------
set mouse=a                                                           "Enable mouse
set nocompatible                                                      "Disable vi compatibility. Because we're not in 1995
set tw=0                                                              "Disable automactic line wrapping
set noerrorbells                                                      "Disable beeping
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

" restore file cursor position
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

" Increase the maximum amount of memory to use for pattern matching
set maxmempattern=2000

" Maximize current window
command Foc execute "winc | | winc _"
" Show all windows
command Unfoc execute "winc ="

" save on enter
nnoremap <silent> <expr> <cr> empty(&buftype) ? ':w<cr>' : '<cr>'

" search mappings
nnoremap <silent> <leader>ss :Grepper -tool rg<cr>
nnoremap <leader>sr :Rg

function! s:search_term_under_cursor()
  execute "Rg " expand("<cword>")
endfunction
nnoremap <leader>st :call <SID>search_term_under_cursor()<CR>

" autoremove trailing whitespace
autocmd BufWritePre * FixWhitespace

" shell-like navigation while in normal mode
inoremap <c-b> <c-\><c-o>h
inoremap <c-f> <c-\><c-o>l
" ---------------------------------------------------------------------

" ------------------------------ COLORS ------------------------------
colorscheme jellybeans
" ---------------------------------------------------------------------

" ------------------------------ SPACES & TABS -----------------------------
set tabstop=4               "Number of visual spaces per TAB
set softtabstop=4           "Number of spaces in tab when editing
set expandtab               "Tabs are spaces
set shiftwidth=4            "Indent with 2 spaces

autocmd Filetype yaml set tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype ruby set tabstop=2 softtabstop=2 shiftwidth=2
" ---------------------------------------------------------------------

" ------------------------------ UI CONFIG ------------------------------
set number                              "Show line numbers
filetype indent on                      "Load filetype-specific indent files
set wildmode=longest,full               "Complete till longest common string && Complete the next full match
set lazyredraw                          "Redraw only when we need to.
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
set hlsearch                "Highlight matches
set ignorecase              "Ignore case on search
set smartcase
" ---------------------------------------------------------------------

lua <<EOF
require('config.lsp')
require('config.lspstatus')
require('config.treesitter')
require('config.cmp')
EOF

" ---------------------------------------------------------------------

" ---------------------- LEFT MARGIN ----------------------------------
"  keep the left margin open always
set signcolumn=yes:1
" show diagnostics in preference to git modification symbols
let signify_priority=5
" ---------------------------------------------------------------------

" --------------------- COMPLETION ------------------------------------
set completeopt=menu,menuone,noselect
set shortmess+=c
" ---------------------------------------------------------------------

" ------------------------------ FOLDING ------------------------------
set foldenable
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
set foldmethod=expr
" ---------------------------------------------------------------------

" -------------------------- AUTO FORMAT ------------------------------
augroup AutoFormat
    autocmd!
    autocmd BufWritePre *.go lua LSP_organize_imports()
    autocmd BufWritePre *.rb lua vim.lsp.buf.formatting_sync(nil, 3000)
    autocmd BufWritePre *.md PrettierAsync
augroup END
" ---------------------------------------------------------------------

" ------------------------------ MOVEMENT ------------------------------
"Move vertically (down) by visual line
nnoremap j gj
"Move vertically (up) by visual line
nnoremap k gk

" Movement in popup menu
" inoremap <expr> <C-j> pumvisible() ? "\<C-N>" : "\<C-j>"
" inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
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
xnoremap <silent> <expr> p <sid>Repl()
" ---------------------------------------------------------------------

" ------------------------------ CONTINUE INDENTING---------------------
xnoremap > >gv
xnoremap < <gv
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

" Unmap C-j and C-k from NERDTree.
" This breaks vim-tmux integration otherwise.
let g:NERDTreeMapJumpNextSibling = ''
let g:NERDTreeMapJumpPrevSibling = ''

" Do not show whitespace characters in NERDTree window
autocmd FileType nerdtree setlocal nolist

" Show hidden files
let NERDTreeShowHidden=1

" --------------------------------------------------------------------------

" --------------------------------- Lightline --------------------------------

" Lightline configs
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch' ],
      \             [ 'readonly' ],
      \             [ 'relativepath', 'modified' ] ],
      \   'right': [ [ 'lspstatus'],
      \              [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype', 'encodingformat' ] ],
      \ },
      \ 'component_function': {
      \   'lspstatus': 'LspStatus',
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
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

function! LightlineBranch()
  if &ft == 'nerdtree'
    return ''
  endif
  let branch = FugitiveHead()
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

" Toggle comment with ctrl + /
nmap <C-_> gc$
xmap <C-_> gc

" --------------------------------- Vim-Markdown-Preview --------------------------------

" Use Chrome
let vim_markdown_preview_browser='Google Chrome'

" Use github syntax
let vim_markdown_preview_github=1

" Leave Ctrl-P alone
let vim_markdown_preview_hotkey='<Leader>mp'

" --------------------------------------------------------------------------

" --------------------------- Cool Matching  -------------------------------
" Show number of matches in the command-line
let g:CoolTotalMatches = 1
" --------------------------------------------------------------------------

" --------------------------------- Shfmt  -------------------------------
" Use 2 spaces instead of tabs
let g:shfmt_extra_args = '-i 2 -ci'
let g:shfmt_fmt_on_save = 1
" --------------------------------------------------------------------------

" --------------------------------- Snippets  -------------------------------
""" ultisnips
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-k>'
let g:UltiSnipsJumpBackwardTrigger='<c-j>'
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
let g:startify_custom_header = map(systemlist('fortune | cowsay -f $HOME/cows/eirini.cow'), '"               ". v:val')
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
                  \ { 'type': 'dir',       'header': [   'MRU ' . getcwd()] },
                  \ { 'type': 'files',     'header': [   'MRU']             },
                  \ { 'type': 'sessions',  'header': [   'Sessions']        },
                  \ { 'type': 'bookmarks', 'header': [   'Bookmarks']       },
                  \ { 'type': 'commands',  'header': [   'Commands']        },
                  \ ]
" --------------------------------------------------------------------------

" ------------------Toggle showing whitespaces------------------------------
nnoremap <F3> :set list!<CR>
" --------------------------------------------------------------------------

" ------------------Toggle showing outline view ----------------------------
nmap <F8> :TagbarToggle<CR>
" --------------------------------------------------------------------------
"
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
nmap <silent> <leader>gh :GBrowse<cr>
xmap <silent> <leader>gh :GBrowse<cr>
" --------------------------------------------------------------------------
"
set nolist


" --------------------- GO ALTERNATIVE FILE --------------------------------
" copied from https://github.com/fatih/vim-go

" Test alternates between the implementation of code and the test code.
function! GoAlternateSwitch(bang, cmd) abort
  let file = expand('%')
  if empty(file)
    echo "no buffer name"
    return
  elseif file =~# '^\f\+_test\.go$'
    let l:root = split(file, '_test.go$')[0]
    let l:alt_file = l:root . ".go"
  elseif file =~# '^\f\+\.go$'
    let l:root = split(file, ".go$")[0]
    let l:alt_file = l:root . '_test.go'
  else
    echo "not a go file"
    return
  endif
  if !filereadable(alt_file) && !bufexists(alt_file) && !a:bang
    echo "couldn't find ".alt_file
    return
  elseif empty(a:cmd)
    execute ":edit " .  alt_file
  else
    execute ":" . a:cmd . " " . alt_file
  endif
endfunction

command! -bang A  call GoAlternateSwitch(<bang>0, '')
command! -bang AS call GoAlternateSwitch(<bang>0, 'split')
command! -bang AV call GoAlternateSwitch(<bang>0, 'vsplit')

" --------------------------------------------------------------------------

" ----------------------- JSON / YAML TAGS ---------------------------------
" snakecase converts a string to snake case. i.e: FooBar -> foo_bar
" Copied from tpope/vim-abolish
" Used in go.snippets for json and yaml expansions
function! Snakecase(word) abort
  let word = substitute(a:word, '::', '/', 'g')
  let word = substitute(word, '\(\u\+\)\(\u\l\)', '\1_\2', 'g')
  let word = substitute(word, '\(\l\|\d\)\(\u\)', '\1_\2', 'g')
  let word = substitute(word, '[.-]', '_', 'g')
  let word = tolower(word)
  return word
endfunction
