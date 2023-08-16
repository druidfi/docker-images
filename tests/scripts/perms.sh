#!/usr/bin/env bash

title "Test that pwd is $APP_PATH"

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
expected='775'

title "Test that created folder has permissions $expected"

if [[ "$result" != "$expected" ]]; then
  error "Error! Folder permissions should be '$expected' instead of '$result'"
fi
