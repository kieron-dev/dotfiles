let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
    " This plugin manager
    Plug 'junegunn/vim-plug'

    " Allow vim to do tmux stuff, like open panes for the test plugin
    Plug 'benmills/vimux'
    " Highlights and removes trailing whitespace
    Plug 'bronson/vim-trailing-whitespace'
    " Syntax highlighting for starlark
    Plug 'cappyzawa/starlark.vim'
    " Add mappings to copy to clipboard - doesn't work over ssh
    Plug 'christoomey/vim-system-copy'
    " Navigate through vim splits seamlessly
    Plug 'christoomey/vim-tmux-navigator'
    " Light and configurable statusline
    Plug 'itchyny/lightline.vim'
    " Preview markdown files in the browser
    Plug 'JamshedVesuna/vim-markdown-preview'
    " Test runner integration
    Plug 'janko/vim-test'
    " Generates method stubs for implementing an interface
    Plug 'josharian/impl'
    " Awesome fuzzy finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " Outline viewer for vim
    Plug 'majutsushi/tagbar'
    Plug 'mhinz/vim-grepper'
    " Show git diff in the sign column
    Plug 'mhinz/vim-signify'
    " Fancy start screen
    Plug 'mhinz/vim-startify'
    " Toggle quickfix and location windows
    Plug 'milkypostman/vim-togglelist'
    " Unobtrusive scratch window
    Plug 'mtth/scratch.vim'
    " Our colorscheme
    Plug 'nanotech/jellybeans.vim'
    " Config for built-in nvim lsp
    Plug 'neovim/nvim-lspconfig'
    " LSP source for nvim-cmp
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'onsails/lspkind.nvim'
    " colorscheme
    Plug 'sainnhe/edge'
    Plug 'romainl/Apprentice', {'branch': 'fancylines-and-neovim'}
    Plug 'dracula/vim', {'as': 'dracula'}
    Plug 'nanotech/jellybeans.vim'

    " lsp status helper
    Plug 'nvim-lua/lsp-status.nvim'
    " use built-in syntax highlighting engine
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " ANSI escape sequences concealed, but highlighted as specified
    Plug 'powerman/vim-plugin-AnsiEsc'
    " prettier formatting
    Plug 'prettier/vim-prettier', { 'do': 'npm install', 'for': ['markdown'] }
    " Reveal the commit messages under the cursor in a 'popup window'
    Plug 'rhysd/git-messenger.vim'
    " Make hlsearch more useful
    Plug 'romainl/vim-cool'
    " Selectively illuminating other uses of the current word under the cursor
    Plug 'RRethy/vim-illuminate'
    " Directory tree explorer
    Plug 'scrooloose/nerdtree'
    " Add various code snippets
    Plug 'SirVer/ultisnips'
    " Comment stuff out
    Plug 'tpope/vim-commentary'
    " Unix utility commands
    Plug 'tpope/vim-eunuch'
    " Git wrapper
    Plug 'tpope/vim-fugitive'
    " Make . work with tpope's plugins
    Plug 'tpope/vim-repeat'
    " Open selected code in githb in browser
    Plug 'tpope/vim-rhubarb'
    " Provides mappings to easily delete, change and add surroundings (parentheses, brackets, quotes, XML tags, and more) in pairs
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-sensible'
    " Useful mappings
    Plug 'tpope/vim-unimpaired'
    " Add snippets for Ginkgo BDD testing library for go
    Plug 'trayo/vim-ginkgo-snippets'
    Plug 'trayo/vim-gomega-snippets'
    " Ruby plugin
    Plug 'vim-ruby/vim-ruby'
    " ytt syntax highlighting
    Plug 'vmware-tanzu/ytt.vim'
    " Runs shfmt to auto format the current buffer
    Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
call plug#end()
