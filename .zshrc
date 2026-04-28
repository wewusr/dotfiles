# 1. PATH & ENVIRONMENT (Move this to the top)
export PATH="/usr/games:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:$HOME/usr/local/sbin:$HOME/.local/bin"
export MANPAGER="nvim +Man!"

# 2. Boilerplate & History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
bindkey -e

# 3. Initialize Completion System
autoload -Uz compinit
compinit

# 4. Zinit & Plugins
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting

# 5. Integrations (Now they will find the binaries in the PATH)
eval "$(starship init zsh)"

if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi

# 6. Completion Styles
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-command fzf
clear
# Welcome message with ASCII art
lolcat <<EOF >~/.temp
██╗    ██╗███████╗██╗    ██╗
██║    ██║██╔════╝██║    ██║
██║ █╗ ██║█████╗  ██║ █╗ ██║
██║███╗██║██╔══╝  ██║███╗██║
╚███╔███╔╝███████╗╚███╔███╔╝
 ╚══╝╚══╝ ╚══════╝ ╚══╝╚══╝
Welcome to your terminal, $(whoami)!
Today is $(date +"%A, %B %d, %Y")
EOF
lolcat --force ~/.temp | truesay ~/Downloads/linux_penguin_animal_9362.png -p right

export PATH="/usr/games:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:$HOME/usr/local/sbin:$HOME/.local/bin"

export MANPAGER="nvim +Man!"

alias ana="tldr"
alias brave="brave-browser"
alias cat="bat"
alias cd="__zoxide_z"
alias claer="clear"
alias cls="clear"
alias ctree="cbonsai"
alias df="duf --only local"
alias du="dust"
alias htop="btop"
alias initconda="source /media/wewusr/Linux/downloaded/apps/conda/anaconda/anaconda3/etc/profile.d/conda.sh"
alias install="'apt install'"
alias ka="killall"
alias la="eza --icons -laghH@ --time-style=long-iso"
alias ls="eza --icons=always"
alias lsblk="lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS,UUID,FSTYPE"
alias mna="man"
alias mnt="./home/wewusr/.local/sbin/mnt"
alias mountall="sudo cp ~/fstab /etc/fstab && sudo mount -a && systemctl daemon-reload"
alias nan="tldr"
alias pat="sudo apt"
alias please="sudo"
alias pray="py ~/pray/main.py"
alias pyt="clear ; python3 -q"
alias recov="sudo dpkg --configure -a && sudo apt install -f && sudo apt update && sudo apt upgrade"
alias s="clear ; source ~/.zshrc"
alias smc="py /home/wewusr/smc.py"
alias telehack="ssh -p 2222 guest@telehack.com"
alias z="__zoxide_z"

