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
skindle() {
    # Define HTML tags via XPATH to filter out
    export XSL_TEMPLATE="<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">
    <xsl:template match=\"node()|@*\">
      <xsl:copy>
        <xsl:apply-templates select=\"node()|@*\"/>
      </xsl:copy>
    </xsl:template>

    <xsl:template match=\"script\"/>
    <xsl:template match=\"div[starts-with(@class,'comment') or starts-with(@id,'comment')]\"/>
    <xsl:template match=\"div[starts-with(@class,'sidebar') or starts-with(@id,'sidebar')]\"/>
    <xsl:template match=\"div[starts-with(@class,'footer')  or starts-with(@id,'footer')]\"/>
    <xsl:template match=\"div[starts-with(@class,'share')   or starts-with(@id,'share')]\"/>
    <xsl:template match=  \"*[starts-with(@class,'widget')  or starts-with(@id,'widget')]\"/>
    <xsl:template match=\"div[starts-with(@class,'nav')     or starts-with(@id,'nav')]\"/>

    </xsl:stylesheet>"

    terminal-notifier -title "Send to Kindle" -message "Starting..." &&
    curl $1 -o /tmp/temp.html -sS &&
    # Remove tags and their content that match XSL_TEMPLATE
    xsltproc --html <(echo "$XSL_TEMPLATE") /tmp/temp.html > /tmp/xsltemp.html &&
    ebook-convert /tmp/xsltemp.html /tmp/temp.mobi &&
    # Send converted .mobi file using calibre-smtp
    calibre-smtp --attachment /tmp/temp.mobi --relay smtp.gmail.com --port 587 --username $EMAIL --password $EMAIL_PASSWORD --encryption-method TLS $EMAIL $KINDLE_EMAIL "" &&
    rm /tmp/temp.mobi && rm /tmp/temp.html && rm /tmp/xsltemp.html &&
    terminal-notifier -title "Send to Kindle" -message "Sent!"
} &> /dev/null # Silence stdout and errors

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
