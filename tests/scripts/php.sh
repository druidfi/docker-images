#!/usr/bin/env bash

if [[ -n "$FRANKENPHP_VERSION" ]]; then
  title "Test FrankenPHP version"
  (frankenphp -v && echo -e "") || error "Something wrong with FrankenPHP"
fi

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
php_version=$(php -d error_reporting=22527 -d display_errors=1 -r 'echo phpversion();')

(composer req php:$php_version -n) || error "Composer require for PHP $php_version failed"
(composer config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true) || error "Composer config set failed"
(composer req -W drupal/coder -n) || error "Composer require failed"
