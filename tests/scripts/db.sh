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
