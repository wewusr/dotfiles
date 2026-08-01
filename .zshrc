# 1. PATH & ENVIRONMENT (Move this to the top)
export PATH="/usr/games:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:$HOME/usr/local/sbin:$HOME/.local/bin:$HOME/.local/sbin"
export MANPAGER="nvim +Man!"
export BAT_THEME="tokyonight_moon"
. "$HOME/.atuin/bin/env"

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
zinit light MichaelAquilina/zsh-auto-notify
# zinit light MichaelAquilina/zsh-you-should-use

# 6. Completion Styles
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


clear
# Welcome message with ASCII art
lolcat <<EOF > ~/.temp
██╗    ██╗███████╗██╗    ██╗
██║    ██║██╔════╝██║    ██║
██║ █╗ ██║█████╗  ██║ █╗ ██║
██║███╗██║██╔══╝  ██║███╗██║
╚███╔███╔╝███████╗╚███╔███╔╝
 ╚══╝╚══╝ ╚══════╝ ╚══╝╚══╝
Welcome to your terminal, $(whoami)!
Today is $(date +"%A, %B %d, %Y")$(weather=$(curl -s --max-time 5 "wttr.in/27.77,30.80?format=%C,+%t,+UV+%u,+%w&lang=en" 2>/dev/null) && [ -n "$weather" ] && echo " | $weather")
EOF
lolcat --force ~/.temp | truesay ~/tux.png -p right

# Aliases
alias ana="tldr"
alias claer="clear"
alias cls="clear"
alias ctree="cbonsai"
alias df="duf --only local"
alias du="dust"
alias initconda="source /media/wewusr/Linux/downloaded/apps/conda/anaconda/anaconda3/etc/profile.d/conda.sh"
alias ka="killall"
alias la="eza --icons -laghH@ --time-style=long-iso"
alias ls="eza -a --icons=always"
alias lsblk="lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS,UUID,FSTYPE"
alias mna="man"
alias mnt="./home/wewusr/.local/sbin/mnt"
alias mountall="sudo cp ~/fstab /etc/fstab && sudo mount -a && systemctl daemon-reload"
alias nan="tldr"
alias pat="sudo apt"
alias pyt="clear ; python3 -q"
alias pray="/home/wewusr/python/wew/pray/main.py --lat 27.77678 --lon 30.80251"
alias py="python3"
alias recov="sudo dpkg --configure -a && sudo apt install -f && sudo apt update && sudo apt upgrade"
alias s="clear ; source ~/.zshrc"
alias smc="py /home/wewusr/smc.py"
alias telehack="ssh -p 2222 guest@telehack.com"
alias z="__zoxide_z"
alias zs="nvim ~/.zshrc"
alias ga="git add ."
alias gs="git status"
alias gc="git commit"
alias gps="git push origin main"
alias gpl="git pull origin main"
alias gimp="flatpak run org.gimp.GIMP"
alias doom1="/var/lib/flatpak/app/io.github.fabiangreffrath.Doom/x86_64/stable/805b10cced2093a60ef8a51c2e591bc4a5c3a1f6e41b44e56afcb60fbbf5b879/export/bin/io.github.fabiangreffrath.Doom -iwad ~/.var/app/io.github.fabiangreffrath.Doom/data/crispy-doom/freedoom1.wad"
alias doom2="/var/lib/flatpak/app/io.github.fabiangreffrath.Doom/x86_64/stable/805b10cced2093a60ef8a51c2e591bc4a5c3a1f6e41b44e56afcb60fbbf5b879/export/bin/io.github.fabiangreffrath.Doom -iwad ~/.var/app/io.github.fabiangreffrath.Doom/data/crispy-doom/freedoom2.wad"


# 5. Integrations
eval "$(starship init zsh)"
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
eval "$(zoxide init zsh)"

# 6. Functions
mkcd() { mkdir -p "$1" && cd "$1" }

# Added by Antigravity CLI installer
export PATH="/home/wewusr/.local/bin:$PATH"

# opencode
export PATH=/home/wewusr/.opencode/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
