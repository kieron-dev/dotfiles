# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="risto"

plugins=(
  docker
  docker-compose
  git
  kubectl
  z
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Set language environment
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# Editors
export GIT_EDITOR="nvim"
export KUBE_EDITOR="nvim"

# Custom scripts
export PATH=$HOME/bin:$PATH

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Fuzzy Find
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 15% --border'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/"'

# Direnv
eval "$(direnv hook zsh)"
