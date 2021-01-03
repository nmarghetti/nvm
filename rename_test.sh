#! /usr/bin/env bash

find_name(){
  find test -name "*[\\/:\*\?\"<>\|]*" -o -name "*."
}

main() {
  local filename
  local new_filename
  while read -r filename; do
    new_filename=$(echo "$filename" | sed -r \
      -e "s/\"/'/g" \
      -e 's/</\[/g' \
      -e 's/>/\]/g' \
      -e 's/^(.*)\.$/\1/'
      )
    printf '%s\n%s\n\n' "$filename" "$new_filename"
    [ "$filename" != "$new_filename" ] && git mv "$filename" "$new_filename"
  done < <(find_name)

  if [ "$(find_name | wc -l)" != "0" ]; then
    echo "Still some files to treat:"
    find_name
  else
    echo "Done"
  fi
}

main
