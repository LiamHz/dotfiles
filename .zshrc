# Import auth credentials
source ~/.auth

# iTerm
export LSCOLORS="ExfxcxdxBxexexaxaxaxax"
alias ls='ls -G'
export PROMPT='%~ -> '

# Env variables
export EDITOR="vim"

# Personal website commands
alias tcompile='pandoc --template=~/.pandoc/templates/top.html -c ./styles/blog.css'
alias ncompile='pandoc --template=~/.pandoc/templates/nested.html -c ../styles/blog.css'

# arbtt
alias tt='arbtt-stats'
alias ttd='arbtt-stats --dump-samples'
alias ttd-a='arbtt-stats --dump-samples | grep \* | sort | uniq -c | sort -n'
alias tt-dump='arbtt-dump'

# bat
export BAT_THEME="gruvbox"
alias bat="bat --style=plain"

# ncdu
alias ncdu="ncdu --color dark -x --exclude .git --exclude node_modules"

# fasd
plugins=(fasd)
eval "$(fasd --init auto)"
alias v='f -e vim'                              # Quick opening files with vim via fasd
alias gl='git log --all --color --oneline --decorate --abbrev-commit' # Pretty git log

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias pp="fzf --preview 'bat --style=plain --color=always --line-range :500 {}' --preview-window=right:60%:wrap"
export FZF_DEFAULT_OPTS="--layout=default --bind='ctrl-o:execute($EDITOR {})+abort'"      # Add `--no-height` to make fzf fullscreen
export FZF_DEFAULT_COMMAND="fd --type f"        # Only fzf through type: files
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
cf() { cd $HOME"/Documents" && cd "$(fd -t d | fzf --preview="tree -L 1 {}")" }

# Pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Calibre
export PATH=$PATH:/Applications/calibre.app/Contents/MacOS/

# URL to ebook + send to Kindle
skindle() { curl $1 -o temp.html && ebook-convert temp.html temp.mobi && calibre-smtp --attachment temp.mobi --relay smtp.gmail.com --port 587 --username $EMAIL --password $EMAIL_PASSWORD --encryption-method TLS $EMAIL liam.hinzman_9MgOq7@kindle.com "" && rm temp.mobi && rm temp.html}

# over-the-wire CTF
alias sshotw='ssh bandit.labs.overthewire.org -p 2220'

# Mirror window and tab name
# Useful for arbtt tracking
set_iterm_name() {
  mode=$1; shift
  echo -ne "\033]$mode;$@\007"
}
iterm_both () { set_iterm_name 0 $@; }
iterm_tab () { set_iterm_name 1 $@; }
iterm_window () { set_iterm_name 2 $@; }

# Haskell
[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"
