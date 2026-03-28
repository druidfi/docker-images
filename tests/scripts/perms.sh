#!/usr/bin/env bash

title "Test that pwd is $APP_PATH"

sudo_bin=$(command -v doas || command -v sudo)

result=$(pwd)
expected=$APP_PATH

if [[ "$result" != "$expected" ]]; then
  error "Error! pwd should be $expected instead of $result"
fi

title "Test that user is druid"

result=$(whoami)
expected=$DEFAULT_USER

if [[ "$result" != "$expected" ]]; then
  error "Error! user should be $expected instead of $result"
fi

folders=( "/home/druid" "/home/druid/.composer" )
for folder in "${folders[@]}"
do
  title "Test that druid owns $folder"

  result=$(stat -c '%U' "$folder")
  expected=$DEFAULT_USER

  if [[ "$result" != "$expected" ]]; then
    error "Error! Owner fo $folder should be $expected instead of $result"
  fi
done

title "Test that user can create a folder under $APP_PATH"

mkdir somefolder || error "Cannot create a folder"

folder="$APP_PATH/somefolder/"
result=$(stat -c '%a' "$folder")

if [[ -z "${PHP_INSTALL_VERSION}" ]]; then
  expected='755'
else
  expected='775'
fi

title "Test that created folder has permissions $expected"

if [[ "$result" != "$expected" ]]; then
  error "Error! Folder permissions should be '$expected' instead of '$result'"
fi

title "Test that druid can unlink www-data-owned files in a www-data:www-data 775 folder"

# PHP-FPM runs as www-data with umask 002, so files/dirs in sites/default/files are
# www-data:www-data with permissions 664/775. Druid (member of www-data group) must be
# able to unlink these files so that drush deploy can clear aggregated CSS/JS caches.
folder="$APP_PATH/folder-owned-by-www-data/"

mkdir "$folder" || error "Cannot create a folder"
$sudo_bin chown www-data:www-data "$folder" || error "Cannot chown folder to www-data"
$sudo_bin chmod 775 "$folder" || error "Cannot chmod folder to 775"
$sudo_bin touch "$folder/test.css.gz" || error "Cannot create test file"
$sudo_bin chown www-data:www-data "$folder/test.css.gz" || error "Cannot chown file to www-data"
$sudo_bin chmod 664 "$folder/test.css.gz" || error "Cannot chmod file to 664"

result=$(stat -c '%U:%G %a' "$folder")
title "Folder: $folder : $result"

result=$(stat -c '%U:%G %a' "$folder/test.css.gz")
title "File: $folder/test.css.gz : $result"

rm "$folder/test.css.gz" || error "Cannot unlink www-data-owned file in www-data:www-data 775 folder"
mkdir "$folder/somefolder" || error "Cannot create subfolder"
rm -rf "$folder" || error "Cannot remove folder"
