# Personal website commands
SITE_DIRECTORY='/Users/liamhinzman/Documents/projects/liamhz.github.io'

extract-yaml-header() {
  awk '/\.\.\./{exit}; {print}' $1
}

getSortedEntries() {
  cd "$SITE_DIRECTORY"/md-$1

  # Created sorted array of yaml dates
  for f in *.md
  do
    extract-yaml-header $f | \
    yq r - date 
  done | \
  sort -rn | > sortedDates
}

generateMarkdownArchivePage() {
  if [[ $1 == 'blog' ]]
  then
    pageTitle='Blog Archive'
  elif [[ $1 == newsletter ]]
  then
    pageTitle='Newsletter'
  else
    echo "Parameter $1 to generateArchive isn't valid"
    return [n]
  fi

  getSortedEntries $1

  # Initalize appropriate archive page
  cd "$SITE_DIRECTORY"/md-$1
  sortedDateArray=($(< sortedDates))
  rm sortedDates
  file="../md-pages/$1.md"
  touch $file

  echo ---                        > $file
  echo title: \""${pageTitle}"\" >> $file
  echo ...                       >> $file
  echo                           >> $file
  echo \# "${pageTitle}"         >> $file

  for d in $sortedDateArray
  do
    for f in *.md
    do
      date=$(extract-yaml-header $f | yq r - date)

      if [[ "$date" == "$d" ]]
      then
        title=$(extract-yaml-header $f | yq r - title)

        url=$(extract-yaml-header $f | yq r - url)

        echo "- [$title]($1/$url.html)" >> $file
      fi
    done
  done
}

exportMarkdownPagesToHtml() {
  cd "$SITE_DIRECTORY"
  cd md-$1

  if [[ $1 == 'pages' ]]
  then
    templateName='top'
    exportFolder=''
    cssPath='./styles/page.css'
  elif [[ $1 == 'blog' ]]
  then
    templateName='nested'
    exportFolder='blog/'
    cssPath='../styles/page.css'
  elif [[ $1 == 'newsletter' ]]
  then
    templateName='nested'
    exportFolder='newsletter/'
    cssPath='../styles/page.css'
  else
    echo "Parameter $1 to exportMarkdownPagesToHtml isn't valid"
    return [n]
  fi

  for f in *.md
  do
    pandoc "$f" -o "../$exportFolder${f%.md}.html" \
    --template=~/.pandoc/templates/$templateName.html \
    -c $cssPath
  done
}

site-compile() {
  cd "$SITE_DIRECTORY"

  generateMarkdownArchivePage blog
  generateMarkdownArchivePage newsletter

  exportMarkdownPagesToHtml pages
  exportMarkdownPagesToHtml blog
  exportMarkdownPagesToHtml newsletter

  cd "$SITE_DIRECTORY"
}
