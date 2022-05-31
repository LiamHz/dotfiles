SITE_DIRECTORY='/Users/liamhinzman/Documents/projects/liamhz.github.io'

isModifiedFile() {
  git status --porcelain | cut -c4- | grep -q $1
}

exportMarkdownPagesToHtml() {
  cd "$SITE_DIRECTORY/md-$1"
  exportFolder="$1/"

  if [[ $1 == 'pages' ]]
  then
    exportFolder=''
  fi

  for f in *.md
  do
    echo "$f"
    pandoc "$f" \
    --from=commonmark+yaml_metadata_block \
    --template=~/.pandoc/templates/default2.html \
    --output="../$exportFolder${f%.md}.html"
  done
}

site-compile() {
  exportMarkdownPagesToHtml pages
  exportMarkdownPagesToHtml blog
  exportMarkdownPagesToHtml cooking

  cd "$SITE_DIRECTORY"
}
