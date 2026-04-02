#!/usr/bin/env bash

mariadb --version

title "Test that mariadb-dump reads ssl-ca from [client] config"

result=$(mariadb-dump --print-defaults 2>&1)

if ! echo "$result" | grep -q "ssl-ca"; then
  error "mariadb-dump is not picking up ssl-ca from [client] config"
fi

if ! echo "$result" | grep -q "DigiCertGlobalRootCA"; then
  error "mariadb-dump ssl-ca does not point to DigiCertGlobalRootCA.crt.pem"
fi

title "Test that DigiCertGlobalRootCA.crt.pem exists"

if [ ! -f /opt/ssl/DigiCertGlobalRootCA.crt.pem ]; then
  error "DigiCertGlobalRootCA.crt.pem not found at /opt/ssl/"
fi

title "Test that /etc/drush/drush.yml exists"

if [ ! -f /etc/drush/drush.yml ]; then
  error "/etc/drush/drush.yml not found"
fi

title "Test that /etc/drush/drush.yml contains skip-ssl and structure-tables"

if ! grep -q "skip-ssl" /etc/drush/drush.yml; then
  error "/etc/drush/drush.yml does not contain skip-ssl"
fi

if ! grep -q "no-tablespaces" /etc/drush/drush.yml; then
  error "/etc/drush/drush.yml does not contain no-tablespaces"
fi

if ! grep -q "structure-tables" /etc/drush/drush.yml; then
  error "/etc/drush/drush.yml does not contain structure-tables"
fi
