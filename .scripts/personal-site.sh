# Personal website commands
SITE_DIRECTORY='/Users/liamhinzman/Documents/projects/liamhz.github.io'

isModifiedFile() {
  git status --porcelain | cut -c4- | grep -q $1
}

extractYamlHeader() {
  awk '/\.\.\./{exit}; {print}' $1
}

getSortedEntries() {
  cd "$SITE_DIRECTORY"/md-$1

  # Created sorted array of yaml dates
  for f in *.md
  do
    extractYamlHeader $f | \
    yq e '.date' -
  done | \
  sort -rn | > sortedDates
}

generateMarkdownArchivePage() {
  if [[ $1 == 'blog' ]]
  then
    pageTitle='Blog'
  elif [[ $1 == 'updates' ]]
  then
    pageTitle='Updates'
  else
    echo "Parameter $1 to generateArchive isn't valid"
    return [n]
  fi

  if ! isModifiedFile md-$1/; then
    return 0
  fi

  getSortedEntries $1

  # Initialize appropriate archive page
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
      date=$(extractYamlHeader $f | yq e '.date' -)

      if [[ "$date" == "$d" ]]
      then
        title=$(extractYamlHeader $f | yq e '.title' -)

        url=$(extractYamlHeader $f | yq e '.url' -)

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
    templateName='post'
    exportFolder='blog/'
    cssPath='../styles/page.css'
  elif [[ $1 == 'updates' ]]
  then
    templateName='nested'
    exportFolder='updates/'
    cssPath='../styles/page.css'
  elif [[ $1 == 'cooking' ]]
  then
    templateName='nested'
    exportFolder='cooking/'
    cssPath='../styles/page.css'
  else
    echo "Parameter $1 to exportMarkdownPagesToHtml isn't valid"
    return [n]
  fi

  for f in *.md
  do
    # Only run Pandoc on new or modified files
    if isModifiedFile $f; then
      sed '1,/<script type="text\/vnd.abc">/s//<script type="text\/vnd.abc">\n%abc-2.2\n%%pagewidth 14cm\n%%bgcolor white\n%%topspace 0\n%%composerspace 0\n%%leftmargin 0.8cm\n%%rightmargin 0.8cm\n/' "$f" |
      pandoc "$f" -o "../$exportFolder${f%.md}.html" \
      --template=~/.pandoc/templates/$templateName.html \
      -c $cssPath
    fi
  done
}

generateMarkdownRecipeGallery() {
  if ! isModifiedFile md-cooking/; then
    return 0
  fi

  getSortedEntries $1

  # Initialize appropriate archive page
  cd "$SITE_DIRECTORY"/md-$1
  sortedDateArray=($(< sortedDates))
  rm sortedDates
  file="../md-pages/$1.md"
  touch $file

  echo ---                 > $file
  echo title: \"Cooking\" >> $file
  echo ...                >> $file
  echo                    >> $file

  echo \# "Recipes" >> $file
  echo >> $file
  echo "<div class='image-gallery'>" >> $file

  for d in $sortedDateArray
  do
    for f in *.md
    do
      date=$(extractYamlHeader $f | yq e '.date' -)

      # TODO this results in unexpected behavior if
      #      multiple posts have the same date
      if [[ "$date" == "$d" ]]
      then
        title=$(extractYamlHeader $f | yq e '.title' -)

        url=$(extractYamlHeader $f | yq e '.url' -)

        img=$(extractYamlHeader $f | yq e '.img' -)

        #echo "[![Image of $title]($img)][($1/$url.html)]" >> $file
        #echo "<a href='$1/$url.html'><img src=\"$img\")]($1/$url.html)" >> $file
        echo "[<img src=\"$img\">]($1/$url.html)" >> $file
        echo "[$title]($1/$url.html)"   >> $file
        echo                            >> $file

        # TODO Create grid layout CSS for recipe gallery
        #      Re-use commented out code on home page

        # TODO Add cooking link to nav bar pandoc templates
      fi
    done
  done

  echo "</div>" >> $file
}

site-compile() {
  cd "$SITE_DIRECTORY"

  generateMarkdownArchivePage blog
  generateMarkdownArchivePage updates

  generateMarkdownRecipeGallery cooking

  exportMarkdownPagesToHtml pages
  exportMarkdownPagesToHtml blog
  exportMarkdownPagesToHtml updates
  exportMarkdownPagesToHtml cooking

  cd "$SITE_DIRECTORY"
}
