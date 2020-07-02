# Import auth credentials
source ~/.auth

# Enable vi keybinds
set -o vi
# Set delay on <esc> to 10ms
KEYTIMEOUT=1

# Import all custom shell functions from directory
for f in ~/.scripts/* ; do
    source $f
done

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
export FZF_DEFAULT_OPTS="--layout=default --bind='ctrl-o:execute($EDITOR {})+abort'"      # Add `--no-height` to make fzf fullscreen
# fzf with code preview
alias vpp="fzf --preview 'bat --style=plain --color=always --line-range :500 {}' --preview-window=right:60%:wrap --bind='enter:execute($EDITOR {})+abort'"
# fzf with grep and code preview
fpp() {
    if (($# == 0)) ; then
        vpp
    else
        grep -r -l $1 ./ | fzf --preview 'bat --style=plain --color=always --line-range :500 {}' --preview-window=right:60%:wrap --bind='enter:execute($EDITOR {})+abort'
    fi
}
# fzf git diff
alias gd="git diff --name-only | fzf -m --ansi --preview 'git diff --color=always -- {-1} | diff-so-fancy'"
# fzf directory
cf() { cd $HOME"/Documents" && cd "$(fd -t d | fzf --preview="tree -L 1 {}")" }
# Filter fzf; Affects fzf.vim
export FZF_DEFAULT_COMMAND="fd --type f -E '**/archive/' -E '*.pdf' -E '**/projects/graphics/' -E '**/projects/inate/' -E '*.png' -E '**/node_modules/' -E '*.jpg' -E 'resources/'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

fdd() { fd --type f -E '**/archive/' -E '*.pdf' -E '**/projects/graphics/' -E '**/projects/inate/' -E '*.png' -E '**/node_modules/' -E '*.jpg' -E 'resources/' }

# Pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

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
