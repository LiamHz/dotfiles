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

# fasd
plugins=(fasd)
eval "$(fasd --init auto)"
alias v='f -e vim'                              # Quick opening files with vim via fasd
alias gl='git log --all --color --oneline --decorate --abbrev-commit' # Pretty git log

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--layout=default"      # Add `--no-height` to make fzf fullscreen
export FZF_DEFAULT_COMMAND="fd --type f"        # Only fzf through type: files
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
vf() { $EDITOR "$(fd -E '*.png' | fzf --preview='bat --style=numbers --color=always --line-range :500 {}')" }
cdf() { cd $HOME && cd "$(fd -t d | fzf --preview="tree -L 1 {}")" }

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
