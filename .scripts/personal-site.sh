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
  elif [[ $1 == 'private-repo' ]]
  then
    pageTitle='Private Repo'
  elif [[ $1 == newsletter ]]
  then
    pageTitle='Newsletter'
  else
    echo "Parameter $1 to generateArchive isn't valid"
    return [n]
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
      date=$(extract-yaml-header $f | yq r - date)

      if [[ "$date" == "$d" ]]
      then
        title=$(extract-yaml-header $f | yq r - title)

        url=$(extract-yaml-header $f | yq r - url)

        echo "- [$title]($1/$url.html)" >> $file
      fi
    done
  done

  if [[ $1 == 'private-repo' ]]
  then
    echo >> $file
    echo "If you want notifications for posts or to leave semi-public comments, follow my [Twitter alt](https://twitter.com/LiamHinzman). DM me about anything you find interesting here." >> $file
  fi

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
  elif [[ $1 == 'private-repo' ]]
  then
    templateName='post'
    exportFolder='private-repo/'
    cssPath='../styles/page.css'
  elif [[ $1 == 'newsletter' ]]
  then
    templateName='nested'
    exportFolder='newsletter/'
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
    pandoc "$f" -o "../$exportFolder${f%.md}.html" \
    --template=~/.pandoc/templates/$templateName.html \
    -c $cssPath
  done
}

generateMarkdownRecipeGallery() {
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

  echo \# "How to Feast as a College Student" >> $file
  echo _Meals I love that are cheap, tasty, and easy to make_ >> $file
  echo >> $file
  echo "<div class='image-gallery'>" >> $file

  for d in $sortedDateArray
  do
    for f in *.md
    do
      date=$(extract-yaml-header $f | yq r - date)

      # TODO this results in unexpected behavior if
      #      multiple posts have the same date
      if [[ "$date" == "$d" ]]
      then
        title=$(extract-yaml-header $f | yq r - title)

        url=$(extract-yaml-header $f | yq r - url)

        img=$(extract-yaml-header $f | yq r - img)

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
  generateMarkdownArchivePage newsletter
  generateMarkdownArchivePage private-repo

  generateMarkdownRecipeGallery cooking

  exportMarkdownPagesToHtml pages
  exportMarkdownPagesToHtml blog
  exportMarkdownPagesToHtml newsletter
  exportMarkdownPagesToHtml cooking
  exportMarkdownPagesToHtml private-repo

  cd "$SITE_DIRECTORY"
}
