local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {
        'prettier/vim-prettier',
        run = 'yarn install',
        ft = {'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'},
    }
    use 'JamshedVesuna/vim-markdown-preview'
    use 'SirVer/ultisnips'
    use 'benmills/vimux'
    use 'brianclements/vim-lilypond'
    use 'bronson/vim-trailing-whitespace'
    use 'christoomey/vim-tmux-navigator'
    use {
        'glepnir/galaxyline.nvim',
        branch = 'main'
    }
    use {
        'glepnir/lspsaga.nvim',
        branch = 'main'
    }
    use 'nvim-lua/completion-nvim'
    use 'janko/vim-test'
    use {
        'joshdick/onedark.vim',
        branch = 'main'
    }
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'kyazdani42/nvim-web-devicons'
    use 'lifepillar/vim-solarized8'
    use 'majutsushi/tagbar'
    use 'mhinz/vim-grepper'
    use 'nvim-lua/plenary.nvim'
    use 'mhinz/vim-signify'
    use 'mhinz/vim-startify'
    use 'milkypostman/vim-togglelist'
    use 'mtth/scratch.vim'
    use 'neovim/nvim-lspconfig'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'scrooloose/nerdtree'
    use 'tpope/vim-commentary'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-rhubarb'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
end)
