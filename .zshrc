zmodload zsh/zprof
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

# Path
path+=('/Users/liamhinzman/cli')
export PATH

# Env variables
export EDITOR="vim"

# YouTube download tools
function ytdlm() {
  youtube-dl -i --extract-audio --audio-format mp3 --audio-quality 0 $1
}

# dgraph
alias dgzero="/usr/local/bin/dgraph alpha --lru_mb 1024"
alias dgalpha="/usr/local/bin/dgraph zero"
alias dgratel="/usr/local/bin/dgraph-ratel"

alias p3="python3"
alias yt="mpsyt"

# Misc
alias cl="clear"

# Turbo Boost Switcher
alias tbs="sudo /Applications/Turbo\ Boost\ Switcher.app/Contents/MacOS/Turbo\ Boost\ Switcher"

# Drill SRS
alias srs="drill-srs"

# Doxygen
alias dDoxygen="doxygen docs/doxyfile && open docs/html/files.html"
#alias mDoxygen="rm -r docs/html && /Users/liamhinzman/Documents/resources/applications/m.css/documentation/doxygen.py docs/doxyfile-mcss"

# arbtt
alias tt='arbtt-stats'
alias ttd='arbtt-stats --dump-samples'
alias ttd-a='arbtt-stats --dump-samples | grep \* | sort | uniq -c | sort -n'
alias tt-dump='arbtt-dump'

# Pomodoro
alias pomo='pomodoro'
alias np='noti pomodoro'
alias nb='noti pomodoro 5'

# bat
export BAT_THEME="nord"
alias bat="bat --style=plain"

# ncdu
alias ncdu="ncdu --color dark -x --exclude .git --exclude node_modules"

# fasd
plugins=(fasd)
eval "$(fasd --init auto)"
alias v='f -e vim'           # Quick opening files with vim via fasd

count() {
  find . -name "*.$1" | xargs wc -l
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--layout=default --bind='ctrl-o:execute($EDITOR {})+abort'"      # Add `--no-height` to make fzf fullscreen
# fzf with code preview
alias vp="fzf --preview 'bat --style=plain --color=always --line-range :500 {}' --preview-window=right:60%:wrap --bind='enter:execute($EDITOR {})+abort'"
# fzf with grep and code preview
fp() {
    if (($# == 0)) ; then
        vp
    else
        grep -r -l $1 ./ | fzf --preview 'bat --style=plain --color=always --line-range :500 {}' --preview-window=right:60%:wrap --bind='enter:execute($EDITOR {})+abort'
    fi
}

# fzf directory
#cf() { cd $HOME"/Documents" && cd "$(fd -t d | fzf --preview="tree -L 1 {}")" }
# Filter fzf; Affects fzf.vim
export FZF_DEFAULT_COMMAND="fd --type f -E '**/archive/' -E '*.pdf' -E '**/projects/graphics/' -E '**/projects/inate/' -E '*.png' -E '**/node_modules/' -E '*.jpg' -E 'resources/'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Git aliases
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gs='git status'
alias gl='git log --all --color --oneline --decorate --abbrev-commit' # Pretty git log
alias gd="git diff --name-only | fzf -m --ansi --preview 'git diff --color=always -- {-1} | diff-so-fancy'" # fzf git diff

#fdd() { fd --type f -E '**/archive/' -E '*.pdf' -E '**/projects/graphics/' -E '**/projects/inate/' -E '*.png' -E '**/node_modules/' -E '*.jpg' -E 'resources/' }

# Pyenv
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

# over-the-wire CTF
alias sshotw='ssh bandit.labs.overthewire.org -p 2220'

# Build and run with make
function cb() {
  cd build && cmake .. && make && ./$(awk -F "(" 'NR==1{print substr($2, 1, length($2)-1)}' ../CMakeLists.txt) && cd ..
}

# Mirror window and tab name
# Useful for arbtt tracking
set_iterm_name() {
  mode=$1; shift
  echo -ne "\033]$mode;$@\007"
}
iterm_both () { set_iterm_name 0 $@; }
iterm_tab () { set_iterm_name 1 $@; }
iterm_window () { set_iterm_name 2 $@; }

# Haskell, for arbtt
[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"
