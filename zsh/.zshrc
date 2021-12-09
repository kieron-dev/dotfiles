# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""

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

# Show non-zero exit status
precmd_pipestatus() {
    local exit_status="${(j.|.)pipestatus}"
    if [[ $exit_status = 0 ]]; then
           return 0
    fi
    echo -n ${exit_status}' '
}

# Set Pure ZSH theme
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

# Remove pure theme state (user@hostname) from prompt
prompt_pure_state=()

# Show exit code of last command as a separate prompt character
PROMPT='%(?.%F{#32CD32}.%F{red}❯%F{red})❯%f '

# Show exit status before prompt
PROMPT='%F{red}$(precmd_pipestatus)'$PROMPT

# Fuzzy Find
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 15% --border'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/"'

# Direnv
eval "$(direnv hook zsh)"
