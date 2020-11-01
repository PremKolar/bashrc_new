# ==================================
# source aliases and function
source ~/.bashrcAlias.sh
source ~/.bashrcFunction.sh
source ~/.bashrcPrompt
source ~/.bashrcPriv
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
# ==================================
HISTCONTROL=ignoreboth
HISTSIZE=1000000000
HISTFILESIZE=2000000000
#export TEXINPUTS=".:~/texmf:"
