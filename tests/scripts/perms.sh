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

title "Test that user can operate folders inside folder owned by www-data"

# Challenge: /app/public/sites/default/files is owned by www-data and with permissions drwxr-xr-x
# Druid user cannot do operations which e.g. delete folders inside it.
# Permissions should be changed from drwxr-xr-x to drwxrwxr-x
folder="$APP_PATH/folder-owned-by-www-data/"

mkdir "$folder" || error "Cannot create a folder"
$sudo_bin chown www-data:www-data "$folder" || error "Cannot change owner of folder: $result"
$sudo_bin chmod g+rwx "$folder" || error "Cannot change permissions of folder: $result"
result=$(stat -c '%U:%G %A %a' "$folder")
title "Permissions: $folder : $result"
mkdir "$folder/somefolder" || error "Cannot create a folder inside folder"
ls -lahR "$folder"
rm -rf "$folder" || error "Cannot remove folder with permissions: $result"
