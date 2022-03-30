#!/usr/bin/env bash

title "Test 'php -v'"

(php -v && echo -e "") || error "Something wrong with PHP"

title "Test 'composer --version'"

(composer --version && echo -e "") || error "Something wrong with Composer"

title "Test iconv"

expected='€'
result=$(php -d error_reporting=22527 -d display_errors=1 -r 'echo iconv("UTF-8", "UTF-8//IGNORE", "''€''");')

if [[ "$result" != "$expected" ]]; then
  error "Error! iconv result should be '$expected' instead of '$result'"
fi

title "Test Composer require"

(composer req -W drupal/coder --ignore-platform-reqs -n) || error "Composer require failed"
